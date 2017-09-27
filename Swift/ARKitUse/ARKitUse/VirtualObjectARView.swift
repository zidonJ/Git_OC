//
//  VirtualObjectARView.swift
//  ARKitUse
//
//  Created by 姜泽东 on 2017/9/26.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

import UIKit
import ARKit

class VirtualObjectARView: ARSCNView {

    
    
    
    struct HitTestRay {
        var origin: float3
        var direction: float3
        
        func intersectionWithHorizontalPlane(atY planeY: Float) -> float3? {
            let normalizedDirection = simd_normalize(direction)
            
            // Special case handling: Check if the ray is horizontal as well.
            if normalizedDirection.y == 0 {
                if origin.y == planeY {
                    /*
                     The ray is horizontal and on the plane, thus all points on the ray
                     intersect with the plane. Therefore we simply return the ray origin.
                     */
                    return origin
                } else {
                    // The ray is parallel to the plane and never intersects.
                    return nil
                }
            }
            
            /*
             The distance from the ray's origin to the intersection point on the plane is:
             (`pointOnPlane` - `rayOrigin`) dot `planeNormal`
             --------------------------------------------
             direction dot planeNormal
             */
            
            // Since we know that horizontal planes have normal (0, 1, 0), we can simplify this to:
            let distance = (planeY - origin.y) / normalizedDirection.y
            
            // Do not return intersections behind the ray's origin.
            if distance < 0 {
                return nil
            }
            
            // Return the intersection point.
            return origin + (normalizedDirection * distance)
        }
        
    }
    
    struct FeatureHitTestResult {
        var position: float3
        var distanceToRayOrigin: Float
        var featureHit: float3
        var featureDistanceToHitResult: Float
    }
    
    func virtualObject(at point: CGPoint) -> VirtualObject? {
        
        let hitTestOptions: [SCNHitTestOption: Any] = [.boundingBoxOnly: true]
        let hitTestResults = hitTest(point, options: hitTestOptions)
        
        //lazy惰性计算属性(SequenceType,CollectionType)
        return hitTestResults.lazy.flatMap { result in
            print(result.localNormal,result.worldNormal,result.localCoordinates,result.worldCoordinates)
            return VirtualObject.existingObjectContainingNode(result.node)
        }.first
    }
    
    func worldPosition(fromScreenPosition position: CGPoint, objectPosition: float3?, infinitePlane: Bool = false) -> (position: float3, planeAnchor: ARPlaneAnchor?, isOnPlane: Bool)? {
        /*
         1. 总是做一个命中测试对现有平面锚点.(如果有这样的锚点存在并且只在它们的范围.)
         */
        let planeHitTestResults = hitTest(position, types: .existingPlaneUsingExtent)
        
        if let result = planeHitTestResults.first {
            let planeHitTestPosition = result.worldTransform.translation
            let planeAnchor = result.anchor
            
            // 立即返回——这是最好的结果。
            return (planeHitTestPosition, planeAnchor as? ARPlaneAnchor, true)
        }
        
        /*
         2. 通过命中特征点云的测试获取更多环境的信息,但是还没有返回结果.
         */
        let featureHitTestResult = hitTestWithFeatures(position, coneOpeningAngleInDegrees: 18, minDistance: 0.2, maxDistance: 2.0).first
        let featurePosition = featureHitTestResult?.position
        
        /*
         3. 如果需要的话(没有好的特性击中测试结果),对无限大的平面锚点做命中测试(忽略现实世界).
         */
        if infinitePlane || featurePosition == nil {
            if let objectPosition = objectPosition,
                let pointOnInfinitePlane = hitTestWithInfiniteHorizontalPlane(position, objectPosition) {
                return (pointOnInfinitePlane, nil, true)
            }
        }
        
        /*
         4.如果对无限平面的命中测试跳过或没有无限平面被命中 如果可用则通过命中特征点云的测试获取更多环境的信息(第2步)。
         
         */
        if let featurePosition = featurePosition {
            return (featurePosition, nil, false)
        }
        
        /*
         5. 作为最后手段,对特征进行第二次未过滤的命中测试。如果场景中没有特征,返回的结果将为零。
         */
        let unfilteredFeatureHitTestResults = hitTestWithFeatures(position)
        if let result = unfilteredFeatureHitTestResults.first {
            return (result.position, nil, false)
        }
        
        return nil
    }
}

extension VirtualObjectARView {
    
    func unprojectPoint(_ point: float3) -> float3 {
        return float3(unprojectPoint(SCNVector3(point)))
    }
    
    func hitTestRayFromScreenPosition(_ point: CGPoint) -> HitTestRay? {
        guard let frame = session.currentFrame else { return nil }
        
        let cameraPos = frame.camera.transform.translation
        
        // Note: z: 1.0 will unproject() the screen position to the far clipping plane.
        let positionVec = float3(x: Float(point.x), y: Float(point.y), z: 1.0)
        let screenPosOnFarClippingPlane = unprojectPoint(positionVec)
        
        let rayDirection = simd_normalize(screenPosOnFarClippingPlane - cameraPos)
        return HitTestRay(origin: cameraPos, direction: rayDirection)
    }
    
    func hitTestWithInfiniteHorizontalPlane(_ point: CGPoint, _ pointOnPlane: float3) -> float3? {
        guard let ray = hitTestRayFromScreenPosition(point) else { return nil }
        
        // Do not intersect with planes above the camera or if the ray is almost parallel to the plane.
        if ray.direction.y > -0.03 {
            return nil
        }
        
        /*
         Return the intersection of a ray from the camera through the screen position
         with a horizontal plane at height (Y axis).
         */
        return ray.intersectionWithHorizontalPlane(atY: pointOnPlane.y)
    }
    
    func hitTestWithFeatures(_ point: CGPoint, coneOpeningAngleInDegrees: Float, minDistance: Float = 0, maxDistance: Float = Float.greatestFiniteMagnitude, maxResults: Int = 1) -> [FeatureHitTestResult] {
        
        guard let features = session.currentFrame?.rawFeaturePoints, let ray = hitTestRayFromScreenPosition(point) else {
            return []
        }
        
        let maxAngleInDegrees = min(coneOpeningAngleInDegrees, 360) / 2
        let maxAngle = (maxAngleInDegrees / 180) * .pi
        
        let results = features.points.flatMap { featurePosition -> FeatureHitTestResult? in
            let originToFeature = featurePosition - ray.origin
            
            let crossProduct = simd_cross(originToFeature, ray.direction)
            let featureDistanceFromResult = simd_length(crossProduct)
            
            let hitTestResult = ray.origin + (ray.direction * simd_dot(ray.direction, originToFeature))
            let hitTestResultDistance = simd_length(hitTestResult - ray.origin)
            
            if hitTestResultDistance < minDistance || hitTestResultDistance > maxDistance {
                // Skip this feature - it is too close or too far away.
                return nil
            }
            
            let originToFeatureNormalized = simd_normalize(originToFeature)
            let angleBetweenRayAndFeature = acos(simd_dot(ray.direction, originToFeatureNormalized))
            
            if angleBetweenRayAndFeature > maxAngle {
                // Skip this feature - is is outside of the hit test cone.
                return nil
            }
            
            // All tests passed: Add the hit against this feature to the results.
            return FeatureHitTestResult(position: hitTestResult,
                                        distanceToRayOrigin: hitTestResultDistance,
                                        featureHit: featurePosition,
                                        featureDistanceToHitResult: featureDistanceFromResult)
        }
        
        // Sort the results by feature distance to the ray.
        let sortedResults = results.sorted { $0.distanceToRayOrigin < $1.distanceToRayOrigin }
        
        let remainingResults = sortedResults.dropFirst(maxResults)
        
        return Array(remainingResults)
    }
    
    func hitTestWithFeatures(_ point: CGPoint) -> [FeatureHitTestResult] {
        guard let features = session.currentFrame?.rawFeaturePoints,
            let ray = hitTestRayFromScreenPosition(point) else {
                return []
        }
        
        /*
         Find the feature point closest to the hit test ray, then create
         a hit test result by finding the point on the ray closest to that feature.
         */
        let possibleResults = features.points.map { featurePosition in
            return FeatureHitTestResult(featurePoint: featurePosition, ray: ray)
        }
        let closestResult = possibleResults.min(by: { $0.featureDistanceToHitResult < $1.featureDistanceToHitResult })!
        return [closestResult]
    }
    
}

extension VirtualObjectARView.FeatureHitTestResult {
    /// Add a convenience initializer to `FeatureHitTestResult` for `HitTestRay`.
    /// By adding the initializer in an extension, we also get the default initializer for `FeatureHitTestResult`.
    init(featurePoint: float3, ray: VirtualObjectARView.HitTestRay) {
        self.featureHit = featurePoint
        
        let originToFeature = featurePoint - ray.origin
        self.position = ray.origin + (ray.direction * simd_dot(ray.direction, originToFeature))
        self.distanceToRayOrigin = simd_length(self.position - ray.origin)
        self.featureDistanceToHitResult = simd_length(simd_cross(originToFeature, ray.direction))
    }
}

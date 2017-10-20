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
            
            // 特殊情况处理:检查射线是否水平
            if normalizedDirection.y == 0 {
                if origin.y == planeY {
                    /*
                     光线在水平的平面上,从而对射线的所有点与平面锚相交.因此只返回射线原点。
                     */
                    return origin
                } else {
                    //光线是平行的平面,永不相交。
                    return nil
                }
            }
            /*
             从光线的原点到平面上的交点的距离:('point-on-plane'-'rayorigin')/'planenormal'
             --------------------------------------------
             direction dot plane Normal
             */
            
            // Since we know that horizontal planes have normal(0, 1, 0), we can simplify this to:
            let distance = (planeY - origin.y) / normalizedDirection.y
            
            // 不返回在射线原点后的相交
            if distance < 0 {
                return nil
            }
            // 返回交点
            return origin + (normalizedDirection * distance)
        }
    }
    
    struct FeatureHitTestResult {
        var position: float3
        var distanceToRayOrigin: Float
        var featureHit: float3
        var featureDistanceToHitResult: Float
    }
    
    //MARK:获取节点
    func virtualObject(at point: CGPoint) -> VirtualObject? {
        
        //另一种命中测试 在SCNSceneRenderer(ARSCNView父类的遵守的一个协议)中   boundingBoxOnly代表只做3D物体的外围的命中测试
        let hitTestOptions: [SCNHitTestOption: Any] = [.boundingBoxOnly: true]
        let hitTestResults = hitTest(point, options: hitTestOptions)
        
        //lazy惰性计算属性(支持这两种类型:SequenceType,CollectionType)
        return hitTestResults.lazy.flatMap { result in
            print(result.localNormal,result.worldNormal,result.localCoordinates,result.worldCoordinates)
            return VirtualObject.existingObjectContainingNode(result.node)
        }.first
    }
    
    func worldPosition(fromScreenPosition position: CGPoint, objectPosition: float3?, infinitePlane: Bool = false) -> (position: float3, planeAnchor: ARPlaneAnchor?, isOnPlane: Bool)? {
        
        /*
         .existingPlaneUsingExtent
         .featurePoint
         .existingPlane
         .estimatedHorizontalPlane
         */
        
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
         2. 通过命中特征点云的测试获取更多环境的信息,但这里先不用返回结果.
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
         5. 作为最后手段,对特征点进行第二次不过滤的命中测试。如果场景中没有特征,返回的结果将为零。
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
    
    //命中测试射线
    func hitTestRayFromScreenPosition(_ point: CGPoint) -> HitTestRay? {
        
        //一些情况AR会话可能被打断不可用 需要先判断下
        guard let frame = session.currentFrame else {
            return nil
        }

        //将4维转的3维 去掉旋转弧度
        let cameraPos = frame.camera.transform.translation
        
        // z=1将不会把屏幕位置投射到遥远的平切面
        let positionVec = float3(x: Float(point.x), y: Float(point.y), z: 1.0)
        
        // 把positionVec渲染到3D世界中的点
        let screenPosOnFarClippingPlane = unprojectPoint(positionVec)
        
        let rayDirection = simd_normalize(screenPosOnFarClippingPlane - cameraPos)
        
        return HitTestRay(origin: cameraPos, direction: rayDirection)
    }
    
    //向无限大平面做命中测试
    func hitTestWithInfiniteHorizontalPlane(_ point: CGPoint, _ pointOnPlane: float3) -> float3? {
        guard let ray = hitTestRayFromScreenPosition(point) else { return nil }
        
        // 不要与相机上方的平面相交,或者光线几乎与平面平行。
        if ray.direction.y > -0.03 {
            return nil
        }
        
        /*
         返回从相机穿过屏幕与射线相交在水平面y轴的高度
         */
        return ray.intersectionWithHorizontalPlane(atY: pointOnPlane.y)
    }
    
    //通过命中特征点云做命中测试
    func hitTestWithFeatures(_ point: CGPoint, coneOpeningAngleInDegrees: Float, minDistance: Float = 0, maxDistance: Float = Float.greatestFiniteMagnitude, maxResults: Int = 1) -> [FeatureHitTestResult] {
        
        //ARPointCloud在AR世界坐标系的点的集合  'rawFeaturePoints'用于分析AR世界的追踪
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

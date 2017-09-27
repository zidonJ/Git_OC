//
//  VirtualObject.swift
//  ARKitUse
//
//  Created by 姜泽东 on 2017/9/20.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

import UIKit
import SceneKit

class VirtualObject: SCNNode {
    
    var moduleName: String = ""
    var modelName: String = ""
    var fileExtension: String = ""
    var modelLoaded: Bool = false
    
    //使用最近虚拟对象距离的平均值，以避免对象规模的快速变化。
    private var recentVirtualObjectDistances = [Float]()
    
    init(moduleName:String, modelName:String, fileExtension:String) {
        super.init()
        
        self.moduleName = moduleName
        self.modelName = modelName
        self.fileExtension = fileExtension
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadModel() {
        
        guard let virtualObjectScene = SCNScene(named: "\(modelName).\(fileExtension)",
            inDirectory: "\(moduleName).scnassets/\(modelName)") else {
                return
        }
        
        let wrapperNode = SCNNode()
        
        for child in virtualObjectScene.rootNode.childNodes {
            //基于物理光线和材质的真实抽象的阴影。
            child.geometry?.firstMaterial?.lightingModel = .physicallyBased
            //该节点预计将随时间移动
            child.movabilityHint = .movable
            wrapperNode.addChildNode(child)
        }
        addChildNode(wrapperNode)
        modelLoaded = true
    }
    
    func removeModel() {
        for child in self.childNodes {
            child.removeFromParentNode()
        }
        
        modelLoaded = false
    }
}

extension VirtualObject {
    
    //找当前Scene的根节点
    static func existingObjectContainingNode(_ node: SCNNode) -> VirtualObject? {
        if let virtualObjectRoot = node as? VirtualObject {
            return virtualObjectRoot
        }
        
        guard let parent = node.parent else { return nil }
        
        // Recurse up to check if the parent is a `VirtualObject`.
        return existingObjectContainingNode(parent)
    }
    
    func setPosition(_ newPosition: float3, relativeTo cameraTransform: matrix_float4x4, smoothMovement: Bool) {
        let cameraWorldPosition = cameraTransform.translation
        var positionOffsetFromCamera = newPosition - cameraWorldPosition
        
        // Limit the distance of the object from the camera to a maximum of 10 meters.
        if simd_length(positionOffsetFromCamera) > 10 {
            positionOffsetFromCamera = simd_normalize(positionOffsetFromCamera)
            positionOffsetFromCamera *= 10
        }
        
        /*
         Compute the average distance of the object from the camera over the last ten
         updates. Notice that the distance is applied to the vector from
         the camera to the content, so it affects only the percieved distance to the
         object. Averaging does _not_ make the content "lag".
         */
        if smoothMovement {
            let hitTestResultDistance = simd_length(positionOffsetFromCamera)
            
            // Add the latest position and keep up to 10 recent distances to smooth with.
            recentVirtualObjectDistances.append(hitTestResultDistance)
            recentVirtualObjectDistances = Array(recentVirtualObjectDistances.suffix(10))
            
            let averageDistance = recentVirtualObjectDistances.average!
            let averagedDistancePosition = simd_normalize(positionOffsetFromCamera) * averageDistance
            simdPosition = cameraWorldPosition + averagedDistancePosition
        } else {
            simdPosition = cameraWorldPosition + positionOffsetFromCamera
        }
    }
}

extension Collection where Iterator.Element == Float, IndexDistance == Int {
    /// Return the mean of a list of Floats. Used with `recentVirtualObjectDistances`.
    var average: Float? {
        guard !isEmpty else {
            return nil
        }
        //reduce 把数组元素组合计算为一个值。swift的一个高阶函数
        let sum = reduce(Float(0)) { current, next -> Float in
            return current + next
        }
        
        return sum / Float(count)
    }
}

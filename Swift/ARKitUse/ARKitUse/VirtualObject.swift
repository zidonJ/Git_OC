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

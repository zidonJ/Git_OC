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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = touch?.location(in: self)
        //result
        
        let _:[ARHitTestResult] = hitTest(point!, types: .existingPlaneUsingExtent)
        
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
}

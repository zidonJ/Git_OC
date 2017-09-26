//
//  VirtualObjectInteraction.swift
//  ARKitUse
//
//  Created by 姜泽东 on 2017/9/26.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class VirtualObjectInteraction: NSObject ,UIGestureRecognizerDelegate{
    
    let sceneView: VirtualObjectARView
    var trackedObject:VirtualObject?
    
    init(sceneView:VirtualObjectARView) {
        self.sceneView = sceneView
        
        super.init()
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:)))
        rotationGesture.delegate = self
        sceneView.addGestureRecognizer(rotationGesture)
        
    }
    
    private func objectInteracting(with gesture: UIGestureRecognizer, in view: ARSCNView) -> VirtualObject? {
        for index in 0..<gesture.numberOfTouches {
            let touchLocation = gesture.location(ofTouch: index, in: view)
            
            // Look for an object directly under the `touchLocation`.
            if let object = sceneView.virtualObject(at: touchLocation) {
                return object
            }
        }
        
        // As a last resort look for an object under the center of the touches.
        return sceneView.virtualObject(at: gesture.center(in: view))
    }

    
    @objc
    func didRotate(_ gesture: UIRotationGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            trackedObject = objectInteracting(with: gesture, in: sceneView)
        case .changed:
            guard gesture.state == .changed else {
                return
            }
            trackedObject?.eulerAngles.y -= Float(gesture.rotation)
            
            gesture.rotation = 0
        
        default:
            break
        }
    }
}

extension UIGestureRecognizer {
    func center(in view: UIView) -> CGPoint {
        let first = CGRect(origin: location(ofTouch: 0, in: view), size: .zero)
        
        let touchBounds = (1..<numberOfTouches).reduce(first) { touchBounds, index in
            return touchBounds.union(CGRect(origin: location(ofTouch: index, in: view), size: .zero))
        }
        
        return CGPoint(x: touchBounds.midX, y: touchBounds.midY)
    }
}

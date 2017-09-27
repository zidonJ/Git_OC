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
    private var currentTrackingPosition: CGPoint?
    
    let translateAssumingInfinitePlane = true
    
    
    init(sceneView:VirtualObjectARView) {
        self.sceneView = sceneView
        
        super.init()
        
        let panGesture = ARPanGesture(target: self, action: #selector(didPan(_:)))
        panGesture.delegate = self
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:)))
        rotationGesture.delegate = self
        
        
        sceneView.addGestureRecognizer(panGesture)
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
    
    @objc
    func didPan(_ gesture: ARPanGesture) {
        
        switch gesture.state {
        case .began:
            if let object = objectInteracting(with: gesture, in: sceneView) {
                trackedObject = object
            }
            
        case .changed where gesture.isThresholdExceeded:
            
            guard let object = trackedObject else {
                return
                
            }
            let translation = gesture.translation(in: sceneView)
            
            let currentPosition = currentTrackingPosition ?? CGPoint(sceneView.projectPoint(object.position))
            
            currentTrackingPosition = CGPoint(x: currentPosition.x + translation.x, y: currentPosition.y + translation.y)
            
            gesture.setTranslation(.zero, in: sceneView)
           
        case .changed:
            break
        default:
            currentTrackingPosition = nil
            trackedObject = nil
        }
        
    }
    
    func updateObjectToCurrentTrackingPosition() {
        guard let object = trackedObject, let position = currentTrackingPosition else {
            return
            
        }
        translate(object, basedOn: position, infinitePlane: translateAssumingInfinitePlane)
    }
    
    private func translate(_ object: VirtualObject, basedOn screenPos: CGPoint, infinitePlane: Bool) {
        guard let cameraTransform = sceneView.session.currentFrame?.camera.transform,
            let (position, _, isOnPlane) = sceneView.worldPosition(fromScreenPosition: screenPos,
                                                                   objectPosition: object.simdPosition,
                                                                   infinitePlane: infinitePlane) else { return }
        
        object.setPosition(position, relativeTo: cameraTransform, smoothMovement: !isOnPlane)
    }
}


//MARK:UIGestureRecognizerDelegate
extension VirtualObjectInteraction {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Allow objects to be translated and rotated at the same time.
        return true
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

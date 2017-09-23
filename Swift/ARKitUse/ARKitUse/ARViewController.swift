//
//  ARViewController.swift
//  ARKitUse
//
//  Created by 姜泽东 on 2017/9/20.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController ,ARSessionDelegate ,ARSCNViewDelegate{

    @IBOutlet weak var arSCNView: ARSCNView!
    
    var arSession:ARSession = ARSession()
    
    lazy var arConfiguration: ARConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        //设置追踪方向
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        return configuration
    }()
    
    var objectNode:SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        arSession.delegate = self
        arSCNView.session = arSession
        arSCNView.delegate = self
        arSCNView.automaticallyUpdatesLighting = true        
    }
    
    override func viewDidLayoutSubviews() {
        arSession.run(arConfiguration, options: [.resetTracking,.removeExistingAnchors])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //SCNScene(named: "chair.scn", inDirectory: "Models.scnassets/chair", options: [:])
        guard let scence = SCNScene(named: "Models.scnassets/lamp/lamp.scn") else {
            return
        }
        let virtualNode = scence.rootNode.childNodes[0]
        //virtualNode.position = SCNVector3Make(0, -1, -1)
        arSCNView.scene.rootNode.addChildNode(virtualNode)
        virtualNode.scale = SCNVector3Make(0.5, 0.5, 0.5)
        virtualNode.position = SCNVector3Make(0, -15, -35)
        
        for node in scence.rootNode.childNodes {
            node.scale = SCNVector3Make(0.5, 0.5, 0.5)
            node.position = SCNVector3Make(0, -15, -35)
        }
        
        //做动画可以创建一个空间的节点（Node这个点是三维的），围绕这个空间节点去做动画
        let animationNode = SCNNode()
        //根结点的位置
        animationNode.position = arSCNView.scene.rootNode.position
        arSCNView.scene.rootNode.addChildNode(animationNode)
        animationNode.addChildNode(virtualNode)
        
        let basiAnimation = CABasicAnimation(keyPath: "rotation")
        basiAnimation.duration = 2
        
        basiAnimation.toValue = NSValue(scnVector4: SCNVector4Make(0, 0, 1, Float.pi*2))
        basiAnimation.repeatCount = 5
        animationNode.addAnimation(basiAnimation, forKey: "rotation")
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}

//MARK:ARSKViewDelegate
extension ARViewController {
    
//    public func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        return VirtualObject(moduleName: "Models", modelName: "chair", fileExtension: "scn")
//    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor.isMember(of: ARPlaneAnchor.classForCoder()) {
            let planeAnchor = anchor as! ARPlaneAnchor
            let planeBox = SCNBox(width: CGFloat(planeAnchor.extent.x * 0.3), height: 0,
                                 length: CGFloat(planeAnchor.extent.x * 0.3), chamferRadius: 0)
            planeBox.firstMaterial?.diffuse.contents = UIColor.red
            let planeNode = SCNNode(geometry: planeBox)
            objectNode = planeNode
            planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
            node.addChildNode(planeNode)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds:2), execute: {
                
                let vNode = VirtualObject(moduleName: "Models", modelName: "lamp", fileExtension: "scn")
                vNode.loadModel()
                vNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
                node.addChildNode(vNode)

            })
        }
    }

    public func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
        print("刷新中")
        
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        print("节点更新")
        
    }
    
    
    public func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        
        print("节点移除")
    }
}

//MARK:ARSessionDelegate
extension ARViewController {
    
    //会频繁的调用
    public func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        //print("更新相机位置")
        if objectNode != nil {
            objectNode?.position = SCNVector3Make(frame.camera.transform.columns.3.x,
                                                  frame.camera.transform.columns.3.y,
                                                  frame.camera.transform.columns.3.z)
        }
    }
    
    //添加锚点
    public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        
        print("添加锚点")
    }
    
    
    //刷新锚点
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
        print("刷新锚点")
    }
    
    //移除锚点
    public func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        
        print("移除锚点")
    }
}

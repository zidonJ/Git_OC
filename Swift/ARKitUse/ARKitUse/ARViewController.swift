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

    @IBOutlet weak var arSCNView: VirtualObjectARView!
    
    @IBOutlet weak var arSKView: ARSKView!
    lazy var virtualObjectInteraction = VirtualObjectInteraction(sceneView: arSCNView)
    
    var arSession:ARSession = ARSession()
    
    
    lazy var arConfiguration: ARConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        
        //
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
        print(virtualObjectInteraction)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //SCNScene(named: "chair.scn", inDirectory: "Models.scnassets/chair", options: [:])
        //一个场景,AR世界可以有很多SCNScene
//        guard let scence = SCNScene(named: "Models.scnassets/lamp/lamp.scn") else {
//            return
//        }
//        let virtualNode = scence.rootNode.childNodes[0]
//        //virtualNode.position = SCNVector3Make(0, -1, -1)
//        arSCNView.scene.rootNode.addChildNode(virtualNode)
//        virtualNode.scale = SCNVector3Make(0.5, 0.5, 0.5)
//        virtualNode.position = SCNVector3Make(0, -15, -35)
//
//        for node in scence.rootNode.childNodes {
//            node.scale = SCNVector3Make(0.5, 0.5, 0.5)
//            node.position = SCNVector3Make(0, -15, -35)
//        }
//
//        //做动画可以创建一个空间的节点（Node这个点是三维的），围绕这个空间节点去做动画
//        let animationNode = SCNNode()
//        //根结点的位置
//        animationNode.position = arSCNView.scene.rootNode.position
//        arSCNView.scene.rootNode.addChildNode(animationNode)
//        animationNode.addChildNode(virtualNode)
//
//        let basiAnimation = CABasicAnimation(keyPath: "rotation")
//        basiAnimation.duration = 2
//
//        basiAnimation.toValue = NSValue(scnVector4: SCNVector4Make(0, 0, 1, Float.pi*2))
//        basiAnimation.repeatCount = 5
//        animationNode.addAnimation(basiAnimation, forKey: "rotation")

        
        //当添加一个锚点的时候会自动添加一个节点:这个节点是空的(没有几何模型和材质)。当向根节点添加一个节点的时候并不会创建锚点
//        var translation = matrix_identity_float4x4
//        translation.columns.3.z = -0.3
//        let transform = simd_mul((arSCNView.session.currentFrame?.camera.transform)!, translation)
//
//        let anchor = ARAnchor(transform: transform)
//        arSCNView.session.add(anchor: anchor)
    }
}

//MARK:ARSCNViewDelegate
extension ARViewController {
    
    //SCNSceneRendererDelegate  ARSCNView父类遵循的一个协议方法 每帧都会调用
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        DispatchQueue.main.async {
            self.virtualObjectInteraction.updateObjectToCurrentTrackingPosition()
        }
        
    }
    
    
    public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("添加节点")
        DispatchQueue.main.async {
//            if anchor.isMember(of: ARPlaneAnchor.classForCoder()) {
//                let planeAnchor = anchor as! ARPlaneAnchor
//                let planeBox = SCNBox(width: CGFloat(planeAnchor.extent.x * 0.3), height: 0,
//                                      length: CGFloat(planeAnchor.extent.x * 0.3), chamferRadius: 0)
//                planeBox.firstMaterial?.diffuse.contents = UIColor.green
//                let planeNode = SCNNode(geometry: planeBox)
//                self.objectNode = planeNode
//                planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
//                node.addChildNode(planeNode)
//
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds:2), execute: {
//
//                    let vNode = VirtualObject(moduleName: "Models", modelName: "lamp", fileExtension: "scn")
//                    vNode.loadModel()
//                    vNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
//                    node.addChildNode(vNode)
//                })
//            }
            
            guard let cameraTransform = self.arSession.currentFrame?.camera.transform else {
                    return
            }
            
            let vNode = VirtualObject(moduleName: "Models", modelName: "lamp", fileExtension: "scn")
            vNode.loadModel()

        
            vNode.setPosition(node.simdPosition, relativeTo: cameraTransform, smoothMovement: false)
            
            //这种方式可能不准确 会出现节点错乱跳动 不稳定
//            node.addChildNode(vNode)
            
            self.arSCNView.scene.rootNode.addChildNode(vNode)
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
        DispatchQueue.main.async {
            if self.objectNode != nil {
                self.objectNode?.position = SCNVector3Make(frame.camera.transform.columns.3.x,
                                                      frame.camera.transform.columns.3.y,
                                                      frame.camera.transform.columns.3.z)
            }
        }
    }
    
    //添加锚点，是一个数组
    public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        
        print("添加锚点")
    }
    
    
    //刷新锚点
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
        print("刷新锚点",anchors.count)
    }
    
    //移除锚点
    public func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        
        print("移除锚点")
    }
}

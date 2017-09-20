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

class ARViewController: UIViewController {

    @IBOutlet weak var arSCNView: ARSCNView!
    
    var arSession:ARSession = ARSession()
    
    lazy var arConfiguration: ARConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        return configuration
    }()
    var objectNode:SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        arSCNView.session = arSession
    }
    
    override func viewDidLayoutSubviews() {
        arSession.run(arConfiguration, options: ARSession.RunOptions.resetTracking)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //SCNScene(named: "chair.scn", inDirectory: "Models.scnassets/chair", options: [:])
        guard let scence = SCNScene(named: "Models.scnassets/chair/chair.scn") else {
            return
        }
        let firstNode = scence.rootNode.childNodes[0]
        firstNode.position = SCNVector3Make(0, -1, -1)
        arSCNView.scene.rootNode.addChildNode(firstNode)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}

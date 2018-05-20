//
//  ViewController.swift
//  ar-makevideo
//
//  Created by Arai Koyo on 2018/05/07.
//  Copyright © 2018年 Arai Koyo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
    }
    //touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let result = sceneView.hitTest(touch.location(in: sceneView), types: ARHitTestResult.ResultType.featurePoint)
        //guard
        guard let pointResult = result.last else {return}
        let pointTransform = SCNMatrix4(pointResult.worldTransform)
        let pointVector =  SCNVector3Make(pointTransform.m41,
                                          pointTransform.m42,pointTransform.m43)
        createBall(pointVector)
    }
    //createBall
    func createBall(_ position: SCNVector3){
        
        let colors = [UIColor.white,UIColor.white,UIColor.white,UIColor.darkGray]
        let size:CGFloat = 0.5
        let size_z:CGFloat = 0.01

        let pyramid = SCNPyramid(width: size, height: size, length: size_z)
        let sphere = SCNSphere(radius: size)
        let cube = SCNBox(width: size, height: size, length: size_z, chamferRadius: 0)
        
        let pattern = [sphere,sphere,sphere,pyramid,sphere,cube]
        
        pattern[Int(arc4random_uniform(6))].firstMaterial?.diffuse.contents =
        colors[Int(arc4random_uniform(4))]
        let node = SCNNode(geometry: pattern[Int(arc4random_uniform(6))])

        //node.position = SCNVector3Make(position.x,position.y-0.1,position.z)
        node.position = position
        print(node.position)
        if let camera = sceneView.pointOfView {
            //node.position = camera.convertPosition(position, to: nil)// カメラ位置からの偏差で求めた位置
            print("2")
            print(node.position)

            //node.eulerAngles = camera.eulerAngles  // カメラのオイラー角と同じにする
        }
        sceneView.scene.rootNode.addChildNode(node)
        
        SCNTransaction.animationDuration = 1.5
        node.position.z = -3
        node.opacity = 0
        node.rotation = SCNVector4(0, 0, 1, 5)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

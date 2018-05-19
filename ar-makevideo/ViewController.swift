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
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
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
        
        let colors = [UIColor.darkGray , UIColor.blue, UIColor.red,UIColor.white,UIColor.cyan,UIColor.magenta]
        
        let sphere = SCNSphere(radius: 0.2)
        sphere.firstMaterial?.diffuse.contents =
        colors[Int(arc4random_uniform(5))]
        let node = SCNNode(geometry: sphere)
        node.position = position
        
        sceneView.scene.rootNode.addChildNode(node)
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

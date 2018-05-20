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
        //CreateSwitch()
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
    var isWire = true

    //createBall
    func createBall(_ position: SCNVector3){

        let colors = [UIColor.white]
        let size:CGFloat = 0.5
        let size_z:CGFloat = 0.01

        let pyramid = SCNPyramid(width: size, height: size, length: size_z)
        let sphere = SCNSphere(radius: size)
        let cube = SCNBox(width: size, height: size, length: size_z, chamferRadius: 0)
        
        let pattern = [sphere,sphere,sphere,pyramid,sphere,cube]
        
        pattern[Int(arc4random_uniform(UInt32(pattern.count)))].firstMaterial?.diffuse.contents =
            colors[Int(arc4random_uniform(UInt32(colors.count)))]
        let node = SCNNode(geometry: pattern[Int(arc4random_uniform(6))])

        //node.position = SCNVector3Make(position.x,position.y-0.1,position.z)
        node.position = position
        isWire = randomBoolWithYesPercent(percent: 50)
        
        if(isWire){
            let node_opacity = [0.1 , 0.5, 1.0]
            sceneView.debugOptions = [.showWireframe]
            let num:Int = Int(arc4random_uniform(UInt32(node_opacity.count)))
            node.opacity = CGFloat(node_opacity[num])
        }else{
            sceneView.debugOptions = []
        }
        
        print(node.position)
        if let camera = sceneView.pointOfView {
            //node.position = camera.convertPosition(position, to: nil)// カメラ位置からの偏差で求めた位置
            //node.eulerAngles = camera.eulerAngles  // カメラのオイラー角と同じにする
        }
        sceneView.scene.rootNode.addChildNode(node)
        
        SCNTransaction.animationDuration = 1.5
        node.position.z = -3
        node.opacity = 0
        node.rotation = SCNVector4(0, 0, 1, 5)
    }
    func CreateSwitch(){
        // Swicthを作成する.
        let mySwicth: UISwitch = UISwitch()
        mySwicth.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height - 200)
        // Swicthの枠線を表示する.
        mySwicth.tintColor = UIColor.black
        // SwitchをOnに設定する.
        mySwicth.isOn = true
        // SwitchのOn/Off切り替わりの際に、呼ばれるイベントを設定する.
        mySwicth.addTarget(self, action: #selector(ViewController.onClickMySwicth(sender:)), for: UIControlEvents.valueChanged)
        // SwitchをViewに追加する.
        self.view.addSubview(mySwicth)
    }
    @objc internal func onClickMySwicth(sender: UISwitch){
        if sender.isOn {
            print("on")
            isWire = true
        }
        else {
            print("off")
            isWire = false
        }
    }
    func randomBoolWithYesPercent(percent: UInt32) -> Bool {
        return arc4random_uniform(100) < percent
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

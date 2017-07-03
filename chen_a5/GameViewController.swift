//
//  GameViewController.swift
//  chen_a5
//
//  Created by MC on 2016-02-22.
//  Copyright (c) 2016 MC. All rights reserved.
//

import UIKit
import SpriteKit



class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = MenuScene(size:view.bounds.size)
        //let scene = CharSelectScene(size:view.bounds.size)
        let skView = view as! SKView
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
       // skView.addSubview(<#T##view: UIView##UIView#>)
        
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

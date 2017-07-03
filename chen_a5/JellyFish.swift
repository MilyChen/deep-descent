//
//  JellyFish.swift
//  chen_a5
//
//  Created by MC on 2016-03-24.
//  Copyright © 2016 MC. All rights reserved.
//

import UIKit
import SpriteKit

class JellyFish: SKSpriteNode {
    
    var direction = true
    
    init(){
        let texture = SKTexture(imageNamed:"jfish0.png")
        super.init(texture:texture, color: SKColor.clearColor(),size:texture.size())
        animate()
        
        let random = arc4random_uniform(2)
        if (random == 0){
            self.direction = false
        }

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func animate(){
        var jfishTextures:[SKTexture]=[]
        for i in 0...11 {
            jfishTextures.append(SKTexture(imageNamed: "jfish\(i).png"))
        }
        let jfishAnimation = SKAction.repeatActionForever (SKAction.animateWithTextures(jfishTextures,timePerFrame: 0.15))
        runAction(jfishAnimation)
        
    }
    func getDir()-> Bool{
            return self.direction
    }
    func setDir(desired:Bool){
        self.direction = desired
    }

    
    
}

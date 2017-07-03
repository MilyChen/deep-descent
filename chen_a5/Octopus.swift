//
//  JellyFish.swift
//  chen_a5
//
//  Created by MC on 2016-03-24.
//  Copyright © 2016 MC. All rights reserved.
//

import UIKit
import SpriteKit

class Octopus: SKSpriteNode {
    
    init(){
        let texture = SKTexture(imageNamed:"octo1.png")
        super.init(texture:texture, color: SKColor.clearColor(),size:texture.size())
        animate()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func animate(){
        var jfishTextures:[SKTexture]=[]
        for i in 1...2 {
            jfishTextures.append(SKTexture(imageNamed: "octo\(i).png"))
        }
        let jfishAnimation = SKAction.repeatActionForever (SKAction.animateWithTextures(jfishTextures,timePerFrame: 0.5))
        runAction(jfishAnimation)
        
    }
}

//
//  JellyFish.swift
//  chen_a5
//
//  Created by MC on 2016-03-24.
//  Copyright © 2016 MC. All rights reserved.
//

import UIKit
import SpriteKit

class Life: SKSpriteNode {
    
    init(){
        let texture = SKTexture(imageNamed:"bubble.png")
        super.init(texture:texture, color: SKColor.clearColor(),size:texture.size())
        animate()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func animate(){

        let rotate = SKAction.rotateByAngle(CGFloat(3.14), duration: NSTimeInterval(6))
        let rotateforever = SKAction.repeatActionForever(rotate)
        runAction(rotateforever)
        
        
    }
}

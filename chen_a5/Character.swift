//
//  Character.swift
//  chen_a5
//
//  Created by MC on 2016-03-22.
//  Copyright © 2016 MC. All rights reserved.
//

import UIKit
import SpriteKit



class Character: SKSpriteNode{
    
    private var isParalyzed = false
    private var life = 3

    init(texture: SKTexture!) {
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.life = 3
        self.isParalyzed = false
       // self.Animate()
    }
    
    init() {
        let choosenchar = Player.aplayer.chars[Player.aplayer.getchoosenchar()]
        let texture = SKTexture(imageNamed:choosenchar.imagestr)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        //texture.size()
        self.life = 3
        self.isParalyzed = false
        self.Animate(choosenchar.imagestr,imgn: choosenchar.imgnum)
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setParalysis(desired:Bool){
        self.isParalyzed = desired
    }
    func ParalysisAnimation(){
        let choosenchar = Player.aplayer.chars[Player.aplayer.getchoosenchar()]
        let imgs = choosenchar.imagestr
        let imgn = choosenchar.imgnum
        
        let index1 = imgs.endIndex.advancedBy(-1)
        let subimgs = imgs.substringToIndex(index1)
        
        var Animate:[SKTexture]=[]
        for i in 1...imgn {
            Animate.append(SKTexture(imageNamed: "\(subimgs)\(i).png"))
        }
        Animate.append(SKTexture(imageNamed:"empty"))
        let Animation = SKAction.repeatActionForever (SKAction.animateWithTextures(Animate,timePerFrame: 0.09))
        runAction(Animation)
    }
    
    func Animate(){
        let choosenchar = Player.aplayer.chars[Player.aplayer.getchoosenchar()]
        let imgs = choosenchar.imagestr
        let imgn = choosenchar.imgnum
        
        let index1 = imgs.endIndex.advancedBy(-1)
        let subimgs = imgs.substringToIndex(index1)
        
        var Animate:[SKTexture]=[]
        for i in 1...imgn {
            Animate.append(SKTexture(imageNamed: "\(subimgs)\(i).png"))
        }
        let Animation = SKAction.repeatActionForever (SKAction.animateWithTextures(Animate,timePerFrame: 0.5))
        runAction(Animation)
    }

    func Animate(imgs:String, imgn:Int){
         //TODO
        let index1 = imgs.endIndex.advancedBy(-1)
        let subimgs = imgs.substringToIndex(index1)

        var Animate:[SKTexture]=[]
        for i in 1...imgn {
            Animate.append(SKTexture(imageNamed: "\(subimgs)\(i).png"))
        }
        //Animate.append(SKTexture(imageNamed:"empty"))
        let Animation = SKAction.repeatActionForever (SKAction.animateWithTextures(Animate,timePerFrame: 0.5))
        runAction(Animation)
    }
    
    func checkParalysis() -> Bool{
        return self.isParalyzed
    }
    
    func checklife()-> Int{
        return self.life
    }
    func loselife(){
        self.life -= 1
    }
    func gainlife(){
        if (self.life != 3){
            self.life += 1
        }
    }
}

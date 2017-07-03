//
//  LoseScene.swift
//  chen_a5
//
//  Created by MC on 2016-02-23.
//  Copyright © 2016 MC. All rights reserved.
//

import UIKit
import SpriteKit

class EndScene: SKScene {
    
    var tboundconst = CGFloat(0)
    var topBounds = CGFloat(30)
    var rightBounds = CGFloat(30)
    var leftBounds = CGFloat(30)
    var height = CGFloat(30)
    var width = CGFloat(30)
    var musicbutton = SKSpriteNode()
    

    override func didMoveToView(view:SKView){
        
        
        height = self.frame.size.height
        width = self.frame.size.width
        leftBounds = width/20
        rightBounds = width - leftBounds
        tboundconst = height / 10
        topBounds = height - tboundconst
        
    
        backgroundColor=SKColor.init(red: 0.58, green: 0.83, blue: 0.91, alpha: 1)
        NSLog("Moved to HighScore Scene")
    
        let highscoretxt = SKSpriteNode(texture: SKTexture(imageNamed:"highscoretxt"))
        highscoretxt.position = CGPointMake(size.width/2, size.height * 0.60)
        highscoretxt.size = CGSize(width: self.width/highscoretxt.size.width * 400 , height: self.height/highscoretxt.size.height * 18)
        addChild(highscoretxt)
        

        //xbutton
        let xbutton = SKSpriteNode (imageNamed: "xbutton.png")
        xbutton.name = "xButton"
        xbutton.size = CGSize(width: tboundconst * 0.80 , height:tboundconst * 0.80)
        xbutton.position = CGPoint(x: leftBounds + xbutton.size.width / 5 , y: topBounds + xbutton.size.height * 0.68)
        self.addChild(xbutton)
        //music button
        
        if (Player.aplayer.getmusicv() == true){
            musicbutton = SKSpriteNode (imageNamed:"musicbutton.png")
        }else{
            musicbutton = SKSpriteNode (imageNamed:"nomusicbutton.png")
        }
        musicbutton.name = "musicButton"
        musicbutton.size = CGSize(width: tboundconst * 0.80 , height: tboundconst * 0.80)
        musicbutton.position = CGPoint(x: rightBounds - musicbutton.size.width / 5 , y: topBounds + musicbutton.size.height * 0.68)
        self.addChild(musicbutton)
        
        showscores()
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if (touchedNode.name == "xButton"){
            let newscene = MenuScene(size:size)
            newscene.scaleMode = scaleMode
            view?.presentScene(newscene)
            
            
        }else if (touchedNode.name == "musicButton"){
            if(Player.aplayer.getmusicv()){
                Player.aplayer.stopmusic()
                Player.aplayer.setmusicv(false)
                musicbutton.texture = SKTexture (imageNamed:"nomusicbutton.png")
            }else{
                Player.aplayer.playmusic("bgsong")
                Player.aplayer.setmusicv(true)
                musicbutton.texture = SKTexture (imageNamed:"musicbutton.png")
            }
            
        }
        
    }
    func showscores(){
       // let cur = Player.aplayer.chars
        let hscore = Scores.scores.gethighscores()
        let images = Scores.scores.gethighscoreimages()
        for i in 1...3{
            let place  = SKSpriteNode(texture: SKTexture(imageNamed: "t\(i)"))
            place.xScale = width/place.size.width *  0.14
            place.yScale = height/place.size.height * 0.10
            place.position = CGPoint(x: width/2 * 0.5 , y: height/place.size.height*28 - CGFloat(i)*height/place.size.height * 7 )
            self.addChild(place)
            
            if (hscore[i-1] != 0){
                let tsprite = SKLabelNode(text: String(hscore[i-1]))
               // tsprite.position = CGPoint(x: width/2 , y: height*0.4 - CGFloat(i)*height/place.size.height * 7 - place.size.height/5)
                tsprite.position = CGPoint(x: width/2  , y: height/place.size.height*28 - CGFloat(i)*height/place.size.height * 7 )
                tsprite.fontColor = SKColor.blackColor()
                tsprite.fontSize = self.height / 15
                tsprite.fontName = "AmericanTypewriter-Bold"
                
                self.addChild(tsprite)
                
                let sprite = SKSpriteNode(texture: SKTexture(imageNamed: images[i-1]))
               // sprite.position = CGPoint(x: width/2 * 1.5 , y: height*0.4 - CGFloat(i)*height/place.size.height * 7)
                sprite.position = CGPoint(x: width/2 * 1.5 , y: height/place.size.height*28 - CGFloat(i)*height/place.size.height * 7 )
                self.addChild(sprite)
            }
        }
    }
    
}//endbracket
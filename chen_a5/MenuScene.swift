//
//  MenuScene.swift
//  chen_a5
//
//  Created by MC on 2016-02-23.
//  Copyright © 2016 MC. All rights reserved.
//

import SpriteKit
import UIKit
import Foundation
import AVFoundation


class MenuScene: SKScene {
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
       
        NSLog("Moved to menu scene")
        if(Player.aplayer.getmusicv() && !Player.aplayer.isplaying){
            Player.aplayer.playmusic("bgsong")
        }
        
        //text
        let highscoretxt = SKSpriteNode(texture: SKTexture(imageNamed:"title"))
        highscoretxt.position = CGPointMake(size.width/2, size.height * 0.62)
        highscoretxt.size = CGSize(width: self.width/highscoretxt.size.width * 500 , height: self.height/highscoretxt.size.height * 150)
        addChild(highscoretxt)
        
        //play
        let pbutton = SKSpriteNode (imageNamed: "playbutton.png")
        pbutton.name = "playButton"
        pbutton.size = CGSize(width: tboundconst  , height:tboundconst  )
        pbutton.position = CGPoint(x: self.frame.width/2 - pbutton.size.width * 1.2 , y: self.frame.height * 0.25)
        self.addChild(pbutton)
        
        //info
        let ibutton = SKSpriteNode (imageNamed: "infobutton.png")
        ibutton.name = "infoButton"
        ibutton.size = CGSize(width: tboundconst  , height:tboundconst )
        ibutton.position = CGPoint(x: self.frame.width/2 , y: self.frame.height * 0.25)
        self.addChild(ibutton)
        
        //scores
        let hbutton = SKSpriteNode (imageNamed: "highscorebutton.png")
        hbutton.name = "highscoreButton"
        hbutton.size = CGSize(width: tboundconst , height:tboundconst )
        hbutton.position = CGPoint(x: self.frame.width/2 + hbutton.size.width * 1.2 , y: self.frame.height * 0.25)
        self.addChild(hbutton)
        
        
        //xbutton
        let xbutton = SKSpriteNode (imageNamed: "exitbutton.png")
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
    
    
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if (touchedNode.name == "playButton"){
            let newscene = CharSelectScene(size:size)
            newscene.scaleMode = .AspectFill
            view?.presentScene(newscene)
            
            
        }else if (touchedNode.name == "infoButton"){
            let newscene = RulesScene(size:size)
            newscene.scaleMode = scaleMode
            view?.presentScene(newscene)
           
            
            
        }else if (touchedNode.name == "xButton"){
            
            exit(0)
    
        }else if (touchedNode.name == "highscoreButton"){
            let newscene = EndScene(size:size)
            newscene.scaleMode = scaleMode
            view?.presentScene(newscene)
        }
        else if (touchedNode.name == "musicButton"){
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

}

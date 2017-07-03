//
//  LoseScene.swift
//  chen_a5
//
//  Created by MC on 2016-02-23.
//  Copyright © 2016 MC. All rights reserved.
//

import UIKit
import SpriteKit

class CharSelectScene: SKScene {
    
    var tboundconst = CGFloat(0)
    var topBounds = CGFloat(30)
    var rightBounds = CGFloat(30)
    var leftBounds = CGFloat(30)
    var height = CGFloat(30)
    var width = CGFloat(30)
    var musicbutton = SKSpriteNode()
    var charpreview = SKSpriteNode()
      var gyrobutton = SKSpriteNode()
    
    var choosen = Int()
    
   // var charscene = CharSelectScene()
    
    
    override func didMoveToView(view:SKView){
        backgroundColor=SKColor.init(red: 0.58, green: 0.83, blue: 0.91, alpha: 1)
        //choosen = 0
        height = self.frame.size.height
        width = self.frame.size.width
        leftBounds = width/20
        rightBounds = width - leftBounds
        tboundconst = height / 10
        topBounds = height - tboundconst
        
        NSLog("Moved to Character SelectScene")
        //titlelabel
        let highscoretxt = SKSpriteNode(texture: SKTexture(imageNamed:"selectchartxt"))
        highscoretxt.position = CGPointMake(size.width/2, size.height * 0.95)
        highscoretxt.size = CGSize(width: self.width/highscoretxt.size.width * 800 , height: self.height/highscoretxt.size.height * 30)
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
        
        showchars()
        //charpreview
        charpreview = SKSpriteNode(texture: SKTexture(imageNamed:Player.aplayer.chars[Player.aplayer.getchoosenchar()].imagestr))
        charpreview .position = CGPointMake(size.width/2, size.height * 0.55)
        charpreview .size = CGSize(width: self.width/highscoretxt.size.width * 150 , height: self.height/charpreview .size.height * 28)
        addChild(charpreview )
        
        //playbutton
        let pbutton = SKSpriteNode (imageNamed: "playbutton.png")
        pbutton.name = "playButton"
        pbutton.size = CGSize(width: tboundconst  , height:tboundconst  )
        pbutton.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.12)
        self.addChild(pbutton)
        
        //gyro
        if (Player.aplayer.gyroenabled == true){
            gyrobutton = SKSpriteNode (imageNamed:"yesgyro.png")
        }else{
            gyrobutton = SKSpriteNode (imageNamed:"nogyro.png")
        }
        gyrobutton.name = "gyroButton"
        gyrobutton.size = CGSize(width: tboundconst * 2 , height: tboundconst * 1)
        gyrobutton.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.25)
        self.addChild(gyrobutton)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        
   
        
        if((touchedNode.name) != nil){
            
            let index1 = touchedNode.name!.endIndex.advancedBy(-1)
            let substr = touchedNode.name!.substringToIndex(index1)
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
            }else if( substr == "c"){
            
                let index2 = touchedNode.name!.endIndex.advancedBy(-1)
                let substr2 = touchedNode.name!.substringFromIndex(index2)
               // print("\(substr2)")
                Player.aplayer.setchoosenchar(Int(substr2)!)
                
                charpreview.texture = SKTexture(imageNamed:Player.aplayer.chars[Player.aplayer.getchoosenchar()].imagestr)
                
            }else if(touchedNode.name == "playButton"){
                let newscene = GameScene(size:size)
                newscene.scaleMode = .AspectFill
                view?.presentScene(newscene)
            }
            else if (touchedNode.name == "gyroButton"){
                if(Player.aplayer.gyroenabled){
                    Player.aplayer.gyroenabled = false
                    gyrobutton.texture = SKTexture (imageNamed:"nogyro.png")
                }else{
                    Player.aplayer.gyroenabled = true
                    gyrobutton.texture = SKTexture (imageNamed:"yesgyro.png")
                }
                
            }
        }
    }
    func showchars(){
        let cur = Player.aplayer.chars
        let count = cur.count - 1
        for i in 0...count{
            let sprite = SKSpriteNode(texture: SKTexture(imageNamed:cur[i].imagestr))
            sprite.name = "c\(i)"
            sprite.position = CGPoint(x: CGFloat(i)*width/sprite.size.width * 11 + width/5  , y: height * 0.8)
            self.addChild(sprite)
        }
    }
    

}//endbracket
//
//  GameScene.swift
//  chen_a5
//
//  Created by MC on 2016-02-22.
//  Copyright (c) 2016 MC. All rights reserved.
//

import SpriteKit
import AVFoundation
import CoreMotion

var gplayer : AVAudioPlayer?

func gplaymusic(name: String, ext: String){
        let sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(name, ofType: ext)!)
        do{
            gplayer = try AVAudioPlayer(contentsOfURL:sound)
            gplayer!.prepareToPlay()
            gplayer!.play()

        }catch{
            print("failed")
        }
    }

struct PhysicsCategory {
    static let None : UInt32 = 0
    static let bad_object : UInt32 = 0x1 << 2
    static let char : UInt32 = 0x1 << 1
    static let life : UInt32 = 0x1 << 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
  //  var char: Character = Character(texture: SKTexture(imageNamed: "girl1")) //initilize the player sprite...
    var char: Character = Character()
    var musicbutton = SKSpriteNode()
    var soundbutton = SKSpriteNode()
    var xbutton = SKSpriteNode()
    var topbar = SKSpriteNode()
    
    var bg1 = SKSpriteNode?()
    var bg2 = SKSpriteNode?()
    var scorelabel:SKLabelNode = SKLabelNode()
    
    var tboundconst = CGFloat(0)
    var topBounds = CGFloat(30)
    var rightBounds = CGFloat(30)
    var leftBounds = CGFloat(30)
    var height = CGFloat(30)
    var width = CGFloat(30)
    var espeedx = CGFloat(0)
    var espeedy = CGFloat(0)
    
    var jfspawn :Double = 10
    var ocspawn :Double = 12
    var lifespawn :Double = 25
    
    var motionManager = CMMotionManager()
    
    var destX:CGFloat = 0.0
    var destY:CGFloat = 0.0
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0,0)
        destX = 0.0
        
        jfspawn = 10
        ocspawn = 12
        lifespawn = 25

        /* Setup your scene here */
        height = self.frame.size.height
        width = self.frame.size.width
        leftBounds = width/20
        rightBounds = width - leftBounds
        tboundconst = height / 10
        topBounds = height - tboundconst
        
        espeedx = width/300
        espeedy = height/700
    
        initscore()
        background() //setup background images , topbar and buttons
        setupCharacter() //main character
        SpawnForever() //jellyfish, octopus, lifeob
        incspawnrate()
        
        let gyroenabled = Player.aplayer.gyroenabled
        if (motionManager.accelerometerAvailable == true && gyroenabled == true) {
            self.motionManager.startGyroUpdates()
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        movewaterbackground()
        initlives()
        keepscore()
        gyromovement()
    }
    
    func gyromovement(){
        if let gryoData = motionManager.gyroData{
            let rotationRate = gryoData.rotationRate
            
            if (rotationRate.x != 0 && !self.char.checkParalysis()){
                self.destY = self.char.position.y + CGFloat(-CGFloat(rotationRate.x) * self.height/char.size.height * 5)
                if( self.destY >= topBounds - self.char.size.height/2 ){
                    self.destY = topBounds - self.char.size.height/2
                }else if( self.destY <= 0 + self.char.size.height/2 ){
                    self.destY = 0 + self.char.size.height/2
                }
                let actiony = SKAction.moveToY(destY,duration: 0.1)
                self.char.runAction(actiony)
            }
            if (rotationRate.y != 0 && !self.char.checkParalysis()){
                self.destX = self.char.position.x + CGFloat(CGFloat(rotationRate.y) * self.width/char.size.width * 5)
                if (destX <= leftBounds  ){
                    destX = leftBounds
                }else if (destX >= rightBounds){
                    destX = rightBounds
                }
                let actionx = SKAction.moveToX(destX,duration: 0.1)
                self.char.runAction(actionx)
            }
        }
    }
    
    func background(){
        bg1 = SKSpriteNode(imageNamed: "bgimage.jpg")
        bg1!.size = CGSize(width: width, height: height)
        bg1!.position = CGPoint(x: width/2, y: height/2)
        self.addChild(bg1!)
        
        bg2 = SKSpriteNode(imageNamed: "bgimage.jpg")
        bg2!.size = CGSize(width: width, height: height)
        bg2!.position = CGPoint(x: width/2, y: bg1!.position.y - bg2!.size.height)
        self.addChild(bg2!)
        //topbar
        topbar = SKSpriteNode (imageNamed:"TopBar.png")
        topbar.size = CGSize(width: width, height: tboundconst)
        topbar.position = CGPoint(x:width/2, y: topBounds + topbar.size.height / 2 )
        self.addChild(topbar)
        //xbutton
        let xbutton = SKSpriteNode (imageNamed: "xbutton.png")
        xbutton.name = "xButton"
        xbutton.size = CGSize(width: topbar.size.height * 0.80 , height:topbar.size.height * 0.80)
        xbutton.position = CGPoint(x: leftBounds + xbutton.size.width / 5 , y: topBounds + xbutton.size.height * 0.68)
        self.addChild(xbutton)
        //music button
        if (Player.aplayer.getmusicv() == true){
            musicbutton = SKSpriteNode (imageNamed:"musicbutton.png")
        }else{
            musicbutton = SKSpriteNode (imageNamed:"nomusicbutton.png")
        }
        musicbutton.name = "musicButton"
        musicbutton.size = CGSize(width: topbar.size.height * 0.80 , height:topbar.size.height * 0.80)
        musicbutton.position = CGPoint(x: rightBounds - musicbutton.size.width / 5 , y: topBounds + musicbutton.size.height * 0.68)
        self.addChild(musicbutton)
        //fxsound
        if (Player.aplayer.getmusicfx() == true){
            soundbutton = SKSpriteNode (imageNamed:"yessoundbutton.png")
        }else{
            soundbutton = SKSpriteNode (imageNamed:"nosoundbutton.png")
        }
        soundbutton.name = "soundButton"
        soundbutton.size = CGSize(width: topbar.size.height * 0.80 , height:topbar.size.height * 0.80)
        soundbutton.position = CGPoint(x: rightBounds - soundbutton.size.width / 5 - soundbutton.size.width, y: topBounds + soundbutton.size.height * 0.68)
        self.addChild(soundbutton)
        
    }

    
    func didBeginContact(contact: SKPhysicsContact){
        var first: SKPhysicsBody
        var second: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            first = contact.bodyA
            second = contact.bodyB
        }else{
            first = contact.bodyB
            second = contact.bodyA
        }
    
        if((first.categoryBitMask & PhysicsCategory.char != 0) && (second.categoryBitMask & PhysicsCategory.bad_object != 0)){
            print("Char hit by bad object!")
            charHitByBadObject(second.node as! SKSpriteNode, char_t: first.node as!SKSpriteNode)
        }
            
        else if((first.categoryBitMask & PhysicsCategory.char != 0) && (second.categoryBitMask & PhysicsCategory.life != 0)){
                print("Gained life!")
                self.char.gainlife()
                Player.aplayer.playfxmusic("bubblesong", ext:"wav")
                second.node?.removeFromParent()
                Scores.scores.updatecurscore(5)
        }
    }
    
    func charHitByBadObject(enemy:SKSpriteNode, char_t: SKSpriteNode){
        //self.curlives = curlives - 1
        self.char.loselife()
      
        if (enemy.name == "jfish"){ //become paralyzed
            Player.aplayer.playfxmusic("jfish", ext: "wav")
            print("You got jelly-fished!")
            let wait = SKAction.waitForDuration(NSTimeInterval(3))
            let s1 = SKAction.runBlock(){
                self.char.setParalysis(true)
                //show paralysis animation here
                 self.char.ParalysisAnimation()
                 enemy.removeFromParent()
            }
            let s2 = SKAction.runBlock(){
                self.char.Animate()
                self.char.setParalysis(false)
            }
            runAction(SKAction.sequence([s1,wait,s2]))
        }else if (enemy.name == "octo"){//become blinded
            Player.aplayer.playfxmusic("splat", ext: "mp3")
            print ("You got octopused!")
            let s1 = SKAction.runBlock(){
                enemy.removeFromParent()
                let splat = SKSpriteNode(texture: SKTexture(imageNamed:"inksplat"))
                splat.xScale = self.width / splat.size.width * 1.2
                splat.yScale = self.height / splat.size.height
                splat.position = CGPoint(x: self.width/2 * 1.2 , y: self.height/2)
                splat.zPosition = 1
                splat.userInteractionEnabled = false
                splat.name = "splat"
                self.addChild(splat)
            }
            let s2 = SKAction.runBlock(){
                self.enumerateChildNodesWithName("splat", usingBlock: {
                    node,stop in
                    node.removeFromParent()
                })
            }
            runAction(SKAction.sequence([s1,SKAction.waitForDuration(NSTimeInterval(5)),s2]))
        }//else if....
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch:AnyObject in touches{
            let location = touch.locationInNode(self)
            let theNode = self.nodeAtPoint(location)
            
            if (theNode.name == "xButton"){
               // self.view?.addsubview(optionsview)
                for _ in 1...char.checklife(){
                    char.loselife()
                }
            }else if (theNode.name == "musicButton"){
                if(Player.aplayer.getmusicv()){
                    Player.aplayer.stopmusic()
                    Player.aplayer.setmusicv(false)
                    musicbutton.texture = SKTexture (imageNamed:"nomusicbutton.png")
                }else{
                    Player.aplayer.playmusic("bgsong")
                    Player.aplayer.setmusicv(true)
                    musicbutton.texture = SKTexture (imageNamed:"musicbutton.png")
                }
            }else if (theNode.name == "soundButton"){
                if(Player.aplayer.getmusicfx()){
                    Player.aplayer.setmusicfx(false)
                    soundbutton.texture = SKTexture (imageNamed:"nosoundbutton.png")
                }else{
                    Player.aplayer.setmusicfx(true)
                    soundbutton.texture = SKTexture (imageNamed:"yessoundbutton.png")
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch:AnyObject in touches{
            let location = touch.locationInNode(self)
            let theNode = self.nodeAtPoint(location)
            
            if (theNode.name == "char" && !char.checkParalysis()){
                enumerateChildNodesWithName("char"){node,stop in
                    let char = node as! SKSpriteNode
                    if( location.x >= 0  && location.x <= self.width ){
                        char.position.x = location.x
                    }
                    if(location.y >= 0  && location.y <= self.topBounds - char.size.height/4){
                        char.position.y = location.y
                    }
                }
            }
        }
    }
    

    func incspawnrate(){
        let wait = SKAction.waitForDuration(NSTimeInterval(15))
        let s2 = SKAction.runBlock(){
            //self.removeAllActions() //clear old ones ...this clears everything
            self.removeActionForKey("spawn1")
            self.removeActionForKey("spawn2")
            self.removeActionForKey("spawn3")
            //update spawnrates
            self.jfspawn = self.jfspawn * 0.95
            self.ocspawn = self.ocspawn * 0.95
            self.lifespawn = self.lifespawn * 0.99
            print("Faster!")
        }
        let s3 = SKAction.runBlock(){
            self.SpawnForever() //recall action with new updated speeds!
        }
        let action = (SKAction.sequence([wait,s2,s3]))
        let foreverMove = SKAction.repeatActionForever(action)
        self.runAction(foreverMove)
    }
    
    func initlives(){
        let curlives = char.checklife()
        if (curlives > 0){
            var countlives = 0
            enumerateChildNodesWithName("life"){node,_ in
                countlives = countlives + 1
            }
            enumerateChildNodesWithName("life"){node,_ in
            node.removeFromParent()
            }
            updatelives(curlives)

        }else{ // LOSE SEQUENCE
            let scene = EndScene(size:size)

            Scores.scores.updatehighscores(Scores.scores.getcurrentscore(), image: Player.aplayer.chars[Player.aplayer.getchoosenchar()].imagestr)

            scene.scaleMode = scaleMode
            view?.presentScene(scene)
        }
    }
    func updatelives(count:Int){
        for i in 1...count{
            let life = SKSpriteNode(texture: SKTexture(imageNamed:"bubble.png"))
            life.xScale = self.width/life.size.width / 10
            life.yScale = life.xScale
            life.position = CGPoint(x: (self.width/2 + CGFloat(i) * life.size.width - life.size.width * 2) , y: (self.height - life.size.height/2 * 1.2))
            life.name = "life"
            self.addChild(life)
        }
    }
    
    func setupCharacter(){
        char.xScale = width / char.size.width / 6
        char.yScale = height / char.size.height / 8
        char.position = CGPoint(x: width/2, y: topBounds - char.size.height)
        char.name = "char"
        
        char.physicsBody = SKPhysicsBody(circleOfRadius: char.size.width/2)
        char.physicsBody!.dynamic = true
        char.physicsBody!.categoryBitMask = PhysicsCategory.char
        char.physicsBody!.contactTestBitMask = PhysicsCategory.bad_object
        char.physicsBody!.usesPreciseCollisionDetection = true
        char.zPosition=2
        
        addChild(char)
    }
    
   
    func movewaterbackground(){
        bg1!.position = CGPoint(x: bg1!.position.x, y: bg1!.position.y + height/400)
        bg2!.position = CGPoint(x: bg2!.position.x, y: bg2!.position.y + height/400)
        
        if (bg1!.position.y > self.frame.size.height + (bg1!.size.height/2)){
            bg1!.position = CGPoint(x: width/2, y: bg2!.position.y - bg1!.size.height)
        }
        if (bg2!.position.y > self.frame.size.height + (bg2!.size.height/2)){
            bg2!.position = CGPoint(x: width/2, y: bg1!.position.y - bg2!.size.height)
        }
    }
    
    func addjellyfish(){
        let jfish = JellyFish()
        jfish.name = "jfish"
        
        //position and sizing...
        jfish.xScale = width / jfish.size.width / 7
        jfish.yScale = height / jfish.size.height / 12
        jfish.position = spawnPosition()

        //physics
        jfish.physicsBody = SKPhysicsBody(circleOfRadius: jfish.size.width/2)
        jfish.physicsBody!.dynamic = true
        jfish.physicsBody!.categoryBitMask = PhysicsCategory.bad_object
        jfish.physicsBody!.contactTestBitMask = PhysicsCategory.char
        jfish.physicsBody!.usesPreciseCollisionDetection = true
        
        addChild(jfish)

    
        let move = SKAction.runBlock(){
            if (jfish.position.y > self.topBounds - jfish.size.height / 2){
                jfish.removeFromParent()
                Scores.scores.updatecurscore(10)
                print("Removed a jelly fish")
                Player.aplayer.playfxmusic("clear", ext: "mp3")
            }else{
                jfish.position.y += CGFloat(self.espeedy)
            }
            if (jfish.position.x > self.width - jfish.size.width/2 || jfish.position.x < jfish.size.width/2){
                jfish.setDir(!jfish.getDir())
            }
            if(jfish.getDir() == true){
                  jfish.position.x += self.espeedx
            }else{
                  jfish.position.x -= self.espeedx
            }
        }
        let foreverMove = SKAction.repeatActionForever(SKAction.sequence([move,SKAction.waitForDuration(0.05)]))
        let switchdir = SKAction.runBlock(){
            let random = arc4random_uniform(2)
            if (random == 1){
                jfish.setDir(!jfish.getDir())
            }
        }
        let foreverrandom = SKAction.repeatActionForever(SKAction.sequence([SKAction.waitForDuration(4.5),switchdir]))
        jfish.runAction(foreverMove)
        jfish.runAction(foreverrandom)
    }
    func addoctopus(){
        let octo = Octopus()
        octo.name = "octo"
        
        //position and sizing...
        octo.xScale = width / octo.size.width / 5
        octo.yScale = height / octo.size.height / 8
        octo.position = spawnPosition()
        
        //physics
        octo.physicsBody = SKPhysicsBody(circleOfRadius: char.size.width/2)
        octo.physicsBody!.dynamic = true
        octo.physicsBody!.categoryBitMask = PhysicsCategory.bad_object
        octo.physicsBody!.contactTestBitMask = PhysicsCategory.char 
        octo.physicsBody!.usesPreciseCollisionDetection = true
        
        addChild(octo)
        
        let move = SKAction.runBlock(){
            if (octo.position.y > self.topBounds - octo.size.height / 2){
                octo.removeFromParent()
                Scores.scores.updatecurscore(10)
                print("Removed a octopus!")
                Player.aplayer.playfxmusic("clear", ext: "mp3")
            }else{
                octo.position.y += CGFloat(self.espeedy * 1.2)
            }
        }

        let foreverMove = SKAction.repeatActionForever(SKAction.sequence([move,SKAction.waitForDuration(0.05)]))
        octo.runAction(foreverMove)
    }
    
    func addlife(){
        let lifeob = Life()
        lifeob.name = "lifeob"
        
        //position and sizing...
        lifeob.xScale = width / lifeob.size.width / 8
        lifeob.yScale =  lifeob.xScale
        lifeob.position = spawnPosition()
        
        //physics
        lifeob.physicsBody = SKPhysicsBody(circleOfRadius: char.size.width/2)
        lifeob.physicsBody!.dynamic = true
        lifeob.physicsBody!.categoryBitMask = PhysicsCategory.life
        lifeob.physicsBody!.contactTestBitMask = PhysicsCategory.char
        lifeob.physicsBody!.usesPreciseCollisionDetection = true
        
        addChild(lifeob)
        
        let move = SKAction.runBlock(){
            if (lifeob.position.y > self.topBounds - lifeob.size.height/2){
                lifeob.removeFromParent()
                print("Removed a heart!")
            }else{
                lifeob.position.y += CGFloat(self.height/800)
            }
        }
        let movedown = SKAction.runBlock(){
            lifeob.position.y -= CGFloat(self.height/800)
        }
        let foreverMove = SKAction.repeatActionForever(SKAction.sequence([move,SKAction.waitForDuration(0.05)]))
        let foreverbob = SKAction.repeatActionForever(SKAction.sequence([movedown,SKAction.waitForDuration(1.2)]))
        lifeob.runAction(foreverMove)
        lifeob.runAction(foreverbob)
    }

    func spawnPosition()-> CGPoint{
        let positions = [
            CGPointMake(self.width / 7 , 0),
            CGPointMake(self.width / 7 * 3, 0),
            CGPointMake(self.width / 7 * 5, 0),
        ]
        let randompositionindex = Int(arc4random_uniform(UInt32(positions.count)))
        return positions[randompositionindex]
    }
    
    func SpawnForever() {
        let jf = SKAction.runBlock{self.addjellyfish()}
        let Waitjf = SKAction.waitForDuration(NSTimeInterval(jfspawn))
        let endlessActionjf = SKAction.repeatActionForever(SKAction.sequence([Waitjf,jf]))
        self.runAction(endlessActionjf, withKey:"spawn1")
        
        let oc = SKAction.runBlock{self.addoctopus()}
        let Waitoc = SKAction.waitForDuration(NSTimeInterval(ocspawn))
        let endlessActionoc = SKAction.repeatActionForever(SKAction.sequence([oc,Waitoc]))
        self.runAction(endlessActionoc , withKey:"spawn2")
        
        let li = SKAction.runBlock{self.addlife()}
        let Waitli = SKAction.waitForDuration(NSTimeInterval(lifespawn))
        let endlessActionli = SKAction.repeatActionForever(SKAction.sequence([li,Waitli]))
        self.runAction(endlessActionli , withKey:"spawn3")
        
    }
    func keepscore(){
        let cscore = Scores.scores.getcurrentscore()

        scorelabel.text = String(cscore)
    }
    func initscore(){
        Scores.scores.restartscore()
        self.scorelabel.position = CGPoint(x: width/2, y: topBounds + topbar.size.height * 10 )
        scorelabel.zPosition = 1
        scorelabel.fontColor = SKColor.blackColor()
        scorelabel.fontSize = self.height/17
        scorelabel.fontName = "AmericanTypewriter-Bold"
        addChild(scorelabel)
        
        let scoretext = SKLabelNode(text: "Score:")
        scoretext.position = CGPoint(x: width/4 , y: topBounds + 5)
        scoretext.zPosition = 1
        scoretext.fontColor = SKColor.blackColor()
        scoretext.fontSize = self.height / 30
        scoretext.fontName = "AmericanTypewriter"
        addChild(scoretext)
        
        let lifetext = SKLabelNode(text: "Life:")
        lifetext.position = CGPoint(x: width/4 , y: self.height - self.height/25)
        lifetext.zPosition = 1
        lifetext.fontColor = SKColor.blackColor()
        lifetext.fontSize = self.height / 30
        lifetext.fontName = "AmericanTypewriter"
        addChild(lifetext)

    }


}//end bracket


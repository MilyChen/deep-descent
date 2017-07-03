//
//  AudioPlayer.swift
//  chen_a5
//
//  Created by Mily Chen on 2016-02-24.
//  Copyright © 2016 MC. All rights reserved.
//

import UIKit
import AVFoundation


class charoption{
    var imagestr: String = "" //img name
    var imgnum: Int = 0 //number of images to animate
    var locked = true  // locked or unlocked
    
    init(imgs:String, imgn:Int, lock:Bool){
        self.imagestr = imgs
        self.imgnum = imgn
        self.locked = lock
    }
}


class Player {
    static let aplayer = Player()
    private var music = true // will start with music playing
    private var audioPlayer :AVAudioPlayer?
    private var fxmusic = true // will start with sound effects on..
    var isplaying = false
    var gyroenabled = false
    var chars: [charoption] = [charoption(imgs: "girl1", imgn: 3, lock: false),charoption(imgs: "girl21", imgn: 3, lock: true), charoption(imgs:"boy1",imgn: 2,lock: true), charoption(imgs: "boy21", imgn: 2, lock: true),charoption(imgs: "boy31", imgn: 3, lock: true)]
    
    private var choosen = 0
    

   init(){
        self.audioPlayer = AVAudioPlayer()
        self.fxmusic = NSUserDefaults.standardUserDefaults().boolForKey("fxsound")
        self.music = NSUserDefaults.standardUserDefaults().boolForKey("bgsound")
        self.choosen = 0
        self.gyroenabled = false
    }
    
    func playmusic(name: String){
        let sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(name, ofType: "mp3")!)
        do{
            audioPlayer = try AVAudioPlayer(contentsOfURL:sound)
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
            self.isplaying = true
            
        }catch{
            print("failed")
        }
    }
    
    func playfxmusic(name: String, ext: String){
        let sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(name, ofType: ext)!)
        do{
            if(fxmusic){
                gplayer = try AVAudioPlayer(contentsOfURL:sound)
                gplayer!.prepareToPlay()
                gplayer!.play()
            }
        }catch{
            print("failed")
        }
    }
    func playmenumusic(name: String, ext: String){
        let sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(name, ofType: ext)!)
        do{
            if(music){
                gplayer = try AVAudioPlayer(contentsOfURL:sound)
                gplayer!.prepareToPlay()
                gplayer!.play()
            }
        }catch{
            print("failed")
        }
    }
    func stopmusic () {
        if (self.music) {
            do {
                 self.audioPlayer!.stop()
                self.isplaying = false
            }
        }
    }
    func getmusicv() -> Bool {
        return self.music
    }
    
    func getmusicfx() -> Bool {
        return self.fxmusic
    }
    func setmusicv(desired:Bool ){
        self.music = desired
    }
    func setmusicfx(desired:Bool ){
        self.fxmusic = desired
    }
    

    func setchoosenchar(desired: Int){
        self.choosen = desired
    }
    func getchoosenchar()-> Int{
        return self.choosen
    }
    

    
 
    
    
    
    

}

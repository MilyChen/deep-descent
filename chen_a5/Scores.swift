//
//  Scores.swift
//  chen_a5
//
//  Created by MC on 2016-04-01.
//  Copyright © 2016 MC. All rights reserved.
//

import UIKit
import Foundation


class Scores{
   // private var highscore = [winner]()
    
    private var first = 0
    private var second = 0
    private var third = 0
    private var firstimg = ""
    private var secondimg = ""
    private var thirdimg = ""
    
    private var highscores = [Int]()
    private var highscoreimages = [String]()
    
    private var currentscore = 0
    static let scores = Scores()

    init(){
      //  self.currentscore = 0

          if ((NSUserDefaults.standardUserDefaults().integerForKey("first") as Int?) != nil){
               self.first = NSUserDefaults.standardUserDefaults().integerForKey("first")}
        if ((NSUserDefaults.standardUserDefaults().integerForKey("second") as Int?) != nil){
            self.second = NSUserDefaults.standardUserDefaults().integerForKey("second")}
        if ((NSUserDefaults.standardUserDefaults().integerForKey("third") as Int?) != nil){
            self.third = NSUserDefaults.standardUserDefaults().integerForKey("third")}

        if ((NSUserDefaults.standardUserDefaults().stringForKey("firstimg") as String?) != nil){
            self.firstimg = NSUserDefaults.standardUserDefaults().stringForKey("firstimg")!}
        if ((NSUserDefaults.standardUserDefaults().stringForKey("secondimg") as String?) != nil){
            self.secondimg = NSUserDefaults.standardUserDefaults().stringForKey("secondimg")!}
        if ((NSUserDefaults.standardUserDefaults().stringForKey("thirdimg") as String?) != nil){
            self.thirdimg = NSUserDefaults.standardUserDefaults().stringForKey("thirdimg")!}

        self.highscores.append(first)
        self.highscores.append(second)
        self.highscores.append(third)
        
        self.highscoreimages.append(firstimg)
        self.highscoreimages.append(secondimg)
        self.highscoreimages.append(thirdimg)
    }
    
    func updatecurscore(score:Int){
        self.currentscore += score
    }
    func getcurrentscore()-> Int{
        return self.currentscore
    }
    func restartscore(){
        self.currentscore = 0
    }
    
    func updatehighscores(score:Int, image:String){ //call when game is finished
        //print(highscores)
       // print(highscoreimages)
        var position = -1
            for i in (0...2).reverse(){
                if (score > highscores[i]){
                    position = i
                }
            }
            if( position != -1 ){ //new high score
                if( position <= 1){
                    highscores[2] = highscores[1]
                    highscoreimages[2] = highscoreimages[1]
                    if(position == 0){
                        highscores[1] = highscores[0]
                        highscoreimages[1] = highscoreimages[0]
                    }
                }
                highscores[position] = score//happens to all cases
                highscoreimages[position] = image
                
                print("New High Score! \(score)")
              //  print(highscores)
               // print(highscoreimages)
            }
    }
    func gethighscores() -> [Int]{
        return self.highscores
    }
    func gethighscoreimages() -> [String]{
        return self.highscoreimages
    }
    
}//endbracket


    




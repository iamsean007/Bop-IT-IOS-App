//
//  Instructions_model.swift
//  BOP_IT_APP
//
//  Created by Shivam smasher on 2018-03-06.
//  Copyright © 2018 Shivam Mahendru. All rights reserved.
//

import Foundation


class Instructions_model{
    
    //vars
    private var instructionStr: [String]
    
    private var timerInSeconds: [String:Int]
    
    private var livesAllowed: String
    
    //init
    init(){
        instructionStr = [
//            "Drag To Bottom",
        "Tap Once",         //0 Easiet
        "Swipe Up",         //1
        "Swipe Down",       //2
        "Swipe Left",       //3
        "Swipe Right",      //4
        "Double \nTap",      //5
        "Triple \nTap",      //6
        "Pinch In",         //7
        "Pinch Out"        //8
//        "Drag To Bottom",   //9
//        "Drag To Top",      //10. Hardest
            
//        "Press And Hold"  // really bad one  never ever have this one WORST
        
        ]
        
        timerInSeconds = ["Easy":7, "Medium":5, "Hard":3]
        
        livesAllowed = "❤️❤️❤️❤️❤️"
    }
    
    //getter
    func getInstructions(instructionNumber: Int) -> String{
        
        return instructionStr[instructionNumber]
        
    }
    
    //getting the count
    func getCount() -> Int{
        
        return instructionStr.count
        
    }
    
    //getting lives
    func getLivesAllowed() -> String {
        return livesAllowed
    }
    
    
    //game Timer setting
    func getTimerAccordingToLevel(level:String) -> Int {
        return timerInSeconds[level]!
    }
    
    
    
    
    
}

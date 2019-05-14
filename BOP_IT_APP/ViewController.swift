//
//  ViewController.swift
//  BOP_IT_APP
//
//  Created by Shivam smasher on 2018-03-06.
//  Copyright © 2018 Shivam Mahendru. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation


class ViewController: UIViewController {

    //VARS
    
    //Score label(unchangeable)
    @IBOutlet weak var scoreLabelUNC: UILabel!
    
    //Score Int lable (changeable)
    @IBOutlet weak var scoreLabelC: UILabel!
    
    //Timer label(unchangeable)
    @IBOutlet weak var timerLabelUNC: UILabel!
    
    //Timer Int label (changeable)
    @IBOutlet weak var timerLabelC: UILabel!
    
    // Insturction label in the center (changable)
    @IBOutlet weak var Instructions_text_label: UILabel!
    
    //Lives Hearts
    @IBOutlet weak var gameLives: UILabel!
    var blackHeartNum:Int = 0 //for every lives lost this increases
    
    
    //record game scores data to show on next page and to track highscore
    var recordData:String!
    
    //vars
    var duration: Int = 0 // usually from 1 - 10 (10 being for easiet level)
    var randRange: Int = 0 //for randomly display the instruction from a range of instructions array.
    
    //To track the matches and change level accordingly
    var instMatchesInt = 0
    var userLevel:String = "Easy"
    
    //Me Box ###########
    @IBOutlet weak var dragBox: UILabel!
    

    // instructions model objects
    var instructionsArray = Instructions_model()
    
    
    //score
    var scoreInt = 0
    //timer
    var starting321timerInt = 3 // 3. 2. 1... Go
    var startTimer = Timer()
    
    var gameTimerInt = 10
    var gameTimer = Timer()
    
    var upperBound:Int = 0
    var randNo:Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        defaultSettingBeforeStart()
       
        storeScore()
        
        gestureRecognizers()
        
        
    }
    /**
     * sets the default values for
        * Score int value and label text
        * Timer int value and label text
        * Sets lives value and label
     * starts timer 3.2.1 Go
     * starts game timer after 3.2.1. Go timer
 
     **/
    func defaultSettingBeforeStart(){
        //making label round in shape
        Instructions_text_label.layer.masksToBounds = true
        Instructions_text_label.layer.cornerRadius = Instructions_text_label.frame.width/2
        
        //Setting the Score
        scoreInt = 0 //int value
        scoreLabelC.text = String(scoreInt) //lable text
        
        //set timer for 3.2.1...Go
        starting321timerInt = 3 // 3.2.1.  Go
        Instructions_text_label.text = String(starting321timerInt)
        //no user interaction at this time
        Instructions_text_label.isUserInteractionEnabled = false
  
        //start timer 3.2.1
        start321Timer()
        
        //set gameTimer for 5 seconds
        gameTimerInt = instructionsArray.getTimerAccordingToLevel(level: userLevel)
        timerLabelCheck()
        timerLabelAnimation()
        timerLabelC.text = String(gameTimerInt) //timer label on the right-side
        
        //update the length of instruction array
        upperBound = instructionsArray.getCount()
        
        //sets the lives allowed
        gameLives.text = instructionsArray.getLivesAllowed()
        userLevelCheck()
    }
    /**
     * starts timer 3.2.1 go
     *
    **/
    func start321Timer(){
        //start the timer //3.2.1. GO
        startTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.startGameTimer), userInfo: nil, repeats: true)
        
    }
    /**
     * stores score values for further use in score label and in highscore lable
     * in different views.
     **/
    
    func storeScore(){
        let userDefaults = Foundation.UserDefaults.standard
        let value = userDefaults.string(forKey: "Record")
        recordData = value
        
    }
    
    /**
     * recognizes gestures on the Instructions label and runs correcponding code.
     *
     **/
    func gestureRecognizers(){
        //GESTURE RECOGNIZERS
        // ### Swipe Gestures ###
        let swipeUp = UISwipeGestureRecognizer(target: self, action:  #selector(self.swipeGestureRecieved))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        Instructions_text_label.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGestureRecieved))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        Instructions_text_label.addGestureRecognizer(swipeDown)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGestureRecieved))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        Instructions_text_label.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGestureRecieved))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        Instructions_text_label.addGestureRecognizer(swipeLeft)
        
        // ### Tap Gestures ##/
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapRecieved))
        Instructions_text_label.addGestureRecognizer(tapGesture)
        
        // ### Double Tap Gestures ##/
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapRecieved))
        tapGesture.require(toFail: doubleTapGesture)
        doubleTapGesture.numberOfTapsRequired = 2 //for double tap
        Instructions_text_label.addGestureRecognizer(doubleTapGesture)
        //
        // ### triple Tap Gestures ##/
        let tripleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tripleTapRecieved))
        doubleTapGesture.require(toFail: tripleTapGesture)
//        tripleTapGesture.require(toFail: tapGesture)
        tripleTapGesture.numberOfTapsRequired = 3 //for triple tap
        Instructions_text_label.addGestureRecognizer(tripleTapGesture)
        
        //pinch in gesture
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchRecieved))
        Instructions_text_label.addGestureRecognizer(pinchGesture)
        
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panRecieved))
        dragBox.addGestureRecognizer(panGesture)
        
        
        
        //        if(Instructions_text_label.text == "Drag To Bottom"){
        //            //show the box
        //            dragBox.isHidden = false
        //        }
        
    }
    
    /**
     * Pinch Gestures
     
     * matches the gesture with the instructions label
     * if mathced moves the game forward
     * else deduct lives
     **/
    @objc func pinchRecieved(_ sender: UIPinchGestureRecognizer){
        
        //match with instruc
        if(Instructions_text_label.text == instructionsArray.getInstructions(instructionNumber: 7)){
            
            print(" pinch in required")
            if sender.state == .ended{
                //check if pinched in
                if sender.scale < 1 {
                    print("yes matched pinch in")
                    
                    //move further
                    moveForward()
                }
                else if(sender.scale > 1 ){
                    //false move
                    
                    //deduct score
                    updateScore(-10)
                    
                    animateLableAndToggle()
                    return;
                }
                else{
                    //false move
                    
                    //deduct score
                    updateScore(-10)
                    
                    animateLableAndToggle()
                }
            }
        
            
        }
        else if Instructions_text_label.text == instructionsArray.getInstructions(instructionNumber: 8) {
            print(" pinch Out required")

            if sender.state == .ended{
                //check if pinched out
                if sender.scale > 1 {
                    print("yes matched pinch out")
                    
                    //move further
                    moveForward()
                }
                else if(sender.scale < 1 ){
                    //false move
                    
                    //deduct score
                    updateScore(-10)
                    
                    animateLableAndToggle()
                    return;
                }
                else{
                    //false move
                    
                    //deduct score
                    updateScore(-10)
                    
                    animateLableAndToggle()
                }
            }
            
        }
        
        
    }
    /**
     * Single Tap Gesture
     
     * matches the gesture with the instructions label
     * if mathced moves the game forward
     * else deduct lives
     **/
    @objc func tapRecieved(_ sender: UITapGestureRecognizer){
        
        if sender.state == .ended {
            //match with instruc
            if(Instructions_text_label.text == instructionsArray.getInstructions(instructionNumber: 0)){
                print("yes matched tap")
                
                //move further
                moveForward()
            }
            else if(Instructions_text_label.text == instructionsArray.getInstructions(instructionNumber: 5) || Instructions_text_label.text == instructionsArray.getInstructions(instructionNumber: 6)){
                //do nothing
                //            Instructions_text_label.text = "im back"
                return;
            }
            else{
                //false move
                print("I worked  <-- else block")
                //deduct score
                updateScore(-10)
                
                animateLableAndToggle()
            }
        }
        
        
    }
    
    /**
     * Double Tap gesture
     
     * matches the gesture with the instructions label
     * if mathced moves the game forward
     * else deduct lives
     **/
    @objc func doubleTapRecieved(_ sender: UITapGestureRecognizer){
        
        if sender.state == .ended {
        
            //match with instruc
            if(Instructions_text_label.text == instructionsArray.getInstructions(instructionNumber: 5) || Instructions_text_label.text == instructionsArray.getInstructions(instructionNumber: 0)){
                
                print("yes matched double tap")
                
                //move further
                moveForward()
            }
            else if(Instructions_text_label.text == instructionsArray.getInstructions(instructionNumber: 6)){
                //do nothing
                return;
            }
            else{
                //false move
                
                //deduct score
                updateScore(-10)
                
                animateLableAndToggle()
            }
            
        }
    }
    
    
    /**
     * Triple Tap gesuture
     
     * matches the gesture with the instructions label
     * if mathced moves the game forward
     * else deduct lives
     **/
    @objc func tripleTapRecieved(_ sender: UITapGestureRecognizer){
        if sender.state == .ended {
        
            //match with instruc
            if(Instructions_text_label.text == instructionsArray.getInstructions(instructionNumber: 6)){
                
                print("yes matched triple tap")
                
                //move further
                moveForward()
            }
            else{
                //false move
                
                //deduct score
                updateScore(-10)
                
                animateLableAndToggle()
            }
        }
    }
    
   
    /**
     * Drag/pan gesture &&&&&&&&&&&%%%%%%%%
     
     * matches the gesture with the instructions label
     * if mathced moves the game forward
     * else deduct lives
     **/
    @objc func panRecieved(_ sender: UIPanGestureRecognizer){
        
        
        if sender.state == .began || sender.state == .changed {
            
            let transition = sender.translation(in: view)
            let changeX = (sender.view?.center.x)! + transition.x
            let changeY = (sender.view?.center.y)! + transition.y
            
            //check their bounds
            
            self.dragBox.center = CGPoint(x: changeX, y: changeY)
            sender.setTranslation(CGPoint.zero, in: sender.view)
            
            
        }
        
        //if it got dragged all the way down
            //call next inst
        
//        else
        // deduct score and ..
        
        
    }
    
    
    /**
     * Swipe Gestures
     
     * matches the gesture with the instructions label
     * if mathced moves the game forward
     * else deduct lives
     **/
    @objc func swipeGestureRecieved(sender: UISwipeGestureRecognizer){
        print(sender.direction);
        
        switch sender.direction {
            
        case UISwipeGestureRecognizerDirection.up:
            print("up image swipe");
            //check if the gesture matches with instruction
            if(Instructions_text_label.text==instructionsArray.getInstructions(instructionNumber: 1)){
                //~tracing
                print("yes Up")
                //animates scores label
                //call moveForward
                moveForward()
                
            }
            else{
                
                //deduct score
                updateScore(-10)
                
                animateLableAndToggle()
            }
            break;
            
        case UISwipeGestureRecognizerDirection.down:
            print("down image swipe");
            //check if the gesture matches with instruction
            if(Instructions_text_label.text==instructionsArray.getInstructions(instructionNumber: 2)){
                //~tracing
                print("yes Down")
                
                //call moveForward
                moveForward()
            }
            else{
                //false move
                
                //deduct score
                updateScore(-10)
                
                animateLableAndToggle()
            }
            break;
            
        case UISwipeGestureRecognizerDirection.left:
            print("left image swipe");
            //check if the gesture matches with instruction
            if(Instructions_text_label.text==instructionsArray.getInstructions(instructionNumber: 3)){
                //~tracing
                print("yes Left")
                
                //call moveForward
                moveForward()
                
            }
            else{
                
                //deduct score
                updateScore(-10)
                
                animateLableAndToggle()
            }
            break;
            
            
        case UISwipeGestureRecognizerDirection.right:
            print("Right image swipe");
            //check if the gesture matches with instruction
            if(Instructions_text_label.text==instructionsArray.getInstructions(instructionNumber: 4)){
                //~tracing
                print("yes Right")
                //call moveForward
                moveForward()
            }
            else{
                //deduct score
                updateScore(-10)
                animateLableAndToggle()
            }
            break;
     
        default:
            print("unKnown Gesture");
            break
        }
    }
    
    
    
    func moveForward(){
        
        let randNumber = randomizeWithoutDuplication(randNo,upperBound)
        
        //feedback sound of Ding
        AudioServicesPlaySystemSound(SystemSoundID(1103))
        
        //calls nextInstruction method
        nextInstruction(randNumber)
        
        //calls updateScore
        updateScore()
        
        //calls updateTimerMethod
        updateTimerMethod()
    }
    
    func nextInstruction(_ showThisInstruction: Int){
        randInstrBKColor()
        Instructions_text_label.text = instructionsArray.getInstructions(instructionNumber: showThisInstruction)
        
    }
    
    func updateScore(){
        
        //increases score by 10
        scoreInt += 10
        scoreLabelC.text = String(scoreInt) //show new score
        
        //animates scores label
        scaleDownAndWhiteLable()
        
        //matches values update
        instMatchesInt += 1
        
    }
    
    //substracts 10 from score and animate for a sec
    func updateScore(_ negative:Int){
        blackHeartNum += 1
        
        //if the gesture is dT or tT

        //decreases one life
        oneLiveDown(blackHeartNum)
        
        //animates scores label
        scaleUpAndRedLable()
    }


    func scaleUpAndRedLable (){
        //animate for .3 sec
        UIView.transition(with: scoreLabelC, duration: 0.6, options: .transitionCrossDissolve, animations: {
            self.scoreLabelC.textColor = .red
        }, completion: nil)
        
        //scale font size
        UIView.animate(withDuration: 0.3) {
            self.scoreLabelC.transform = CGAffineTransform(scaleX: 1.2, y: 1.4)
        }
        
    }
    
    func scaleDownAndWhiteLable (){
        //animate for .3 sec
        UIView.transition(with: scoreLabelC, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.scoreLabelC.textColor = .white
        }, completion: nil)
        
       
        
        //scale it back again font size
        UIView.animate(withDuration: 0.3) {
            self.scoreLabelC.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        
        
    }
    
    /**
    * Animates the Score value on decrement
    */
    func animateLableAndToggle(){
        // vibrate as a feedback
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        UIView.animate(withDuration: 0.3, animations: {
            self.scaleUpAndRedLable()
        }, completion: { _ in
            UIView.animate(withDuration: 0.6, delay: 0.3, animations: {
                self.scaleDownAndWhiteLable()
            })
        })
        
        
    }
    
    /**
     * randomizes a number
     **/
    func randomizeWithoutDuplication(_ no : Int, _ upperBn: Int)->Int{
        
        var newRand = Int(arc4random_uniform(UInt32(upperBn)))
        
        let oldNum = no
        //re-randomize the rand
        
        
        if newRand == oldNum {
            //re-initialize
            newRand = randomizeWithoutDuplication(oldNum, upperBn)
        }
        //else
        return newRand
    }
    
    func randInstrBKColor(){
        Instructions_text_label.backgroundColor =  randomColors()
    }
    
    func randomColors()->UIColor{
        return UIColor(
            red: CGFloat(Double(randomizeWithoutDuplication(0,254))/255.0),
            green: CGFloat(Double(randomizeWithoutDuplication(0,254))/255.0),
            blue: CGFloat(Double(randomizeWithoutDuplication(0,254))/255.0), alpha: CGFloat(0.3)
        )
        
        
    }
    
    /**
     * Deletes one life
     **/
    func oneLiveDown(_ heartNo:Int){
        
        if(heartNo==1){
            gameLives.text = "🖤❤️❤️❤️❤️"
        }
        else if(heartNo==2){
            gameLives.text = "🖤🖤❤️❤️❤️"
        }
        else if(heartNo==3){
            gameLives.text = "🖤🖤🖤❤️❤️"
        }
        else if(heartNo==4){
            gameLives.text = "🖤🖤🖤🖤❤️"
        }
        else if(heartNo==5){
            gameLives.text = "🖤🖤🖤🖤🖤"
        }
        else{
            print("oneLiveDown <-- last else so hearNo == \(heartNo)")
            gameOver()
        }
    }
    
    func userLevelCheck(){
        if(instMatchesInt < 5){
            userLevel = "Easy"
        }
        else if(instMatchesInt < 10){
            userLevel = "Medium"
        }
        else{
            userLevel = "Hard"
        }
    }
    
    func turnTimerLableRed(){
        timerLabelC.textColor = .red
    }
    func turnTimerLableWhite(){
        timerLabelC.textColor = .white
    }
    
    func timerLabelCheck(){
        if gameTimerInt < 3 {
            turnTimerLableRed()
        }
        else{
            turnTimerLableWhite()
        }
    }
    
    func timerLabelAnimation(){
        UIView.animate(withDuration: 1, animations: { () -> Void in
            self.timerLabelC.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { (finished: Bool) -> Void in
            UIView.animate(withDuration: 1, animations: { () -> Void in
                self.timerLabelC.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })}
    }
    
    // ****************** Game and Timer Functions *****************
    
    //Game timer kicking function
    @objc func startGameTimer(){
        starting321timerInt -= 1
        Instructions_text_label.text = String(starting321timerInt)
        
        if starting321timerInt == 0 {
            
            startTimer.invalidate()
            
            //set a new instruction
            Instructions_text_label.text = instructionsArray.getInstructions(instructionNumber: randNo)
            
            //enable user interaction
            Instructions_text_label.isUserInteractionEnabled = true
            
            //after 3.2.1. Go ... Starts the Game Timer
            gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.game), userInfo: nil, repeats: true)
        }
        
    }
    /**
    * changes game timer and check if the game is over.
    */
    @objc func game(){
        //decrement 1 from timer.
        gameTimerInt -= 1
        
        //if timer ends or if lives ends ... Game is Over
        if gameTimerInt == 0 {
            //check if there are lives remaining
            if blackHeartNum <= 3 {
                
                //vibrate as feedback
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                
                //increase the black-hearts// one live down
                blackHeartNum += 1
                oneLiveDown(blackHeartNum)
                
                userLevelCheck()
                
                //re-set timer
                gameTimerInt = instructionsArray.getTimerAccordingToLevel(level: userLevel)
            }
            else{
                print("""
                    game <-- if -->else where blackHeartNum == \(blackHeartNum) !<=1 \n
                    gameTimerInt == \(gameTimerInt)\n
                    """)
                gameOver()
            }
        }
        else if blackHeartNum >= 5 || gameTimerInt <= 0{
            print("""
                game <-- else if where blackHeartNum == \(blackHeartNum) >=5 \n OR \n
                gameTimerInt == \(gameTimerInt)\n <=0
                """)
            gameOver()
        }
        
        timerLabelCheck()
        timerLabelAnimation()
        //set the timer lable
        timerLabelC.text = String(gameTimerInt) //update value
        
    }
    
    func gameOver(){
        //stop the timer.
        gameTimer.invalidate()
        
        //compare and save game score to use at next view or for highscore checking
        saveScore()
        
        //disable user interaction
        Instructions_text_label.isUserInteractionEnabled = false
        
        //display GAME OVER
        Instructions_text_label.text = "GAME\nOVER "
        
        //Re-Display game Lives
        gameLives.text = "🖤🖤🖤🖤🖤"
        
        //After game over take me to endGame view in 2 sec
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.end), userInfo: nil, repeats: false)
        
    }
    
    /**
     * After Game over takes to next View
    **/
    @objc func end(){
        
        //End-game view //Last view
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "endGame") as! EndViewController
        //update scores label from the game
        vc.scoreData = scoreLabelC.text
        //show new view
        self.present(vc, animated: true, completion: nil)
        
    }
    /**
     * updates the gameTimer and calls game again
     **/
    func updateTimerMethod(){
        userLevelCheck()
        timerLabelAnimation()
        //set a new timer
        gameTimerInt = instructionsArray.getTimerAccordingToLevel(level: userLevel) + 1
        //start
        game()
        
    }
    func saveScore(){
        //Save score for the next view's Score label
        if recordData == nil{
            let savedString = scoreLabelC.text
            let userDefaults = Foundation.UserDefaults.standard
            userDefaults.set(savedString, forKey:"Record")
        }
        else {
            let score:Int? = Int(scoreLabelC.text!)
            let record:Int? = Int(recordData)
            //check if beats highscore
            if score! > record! {
                let savedString = scoreLabelC.text
                let userDefaults = Foundation.UserDefaults.standard
                userDefaults.set(savedString, forKey:"Record")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


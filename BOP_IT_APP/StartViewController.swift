//
//  StartViewController.swift
//  BOP_IT_APP
//
//  Created by Shivam smasher on 2018-03-07.
//  Copyright © 2018 Shivam Mahendru. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class StartViewController: UIViewController {

    //vars
   
    @IBOutlet weak var highScoreLableUNC: UILabel!
    
    @IBOutlet weak var highScoreIntC: UILabel!
    
    @IBOutlet weak var startBtnUNC: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //rounding the corners
        highScoreLableUNC.layer.masksToBounds = true

        highScoreLableUNC.layer.cornerRadius = 10.0
       
        startBtnUNC.layer.cornerRadius = 10.0
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = Foundation.UserDefaults.standard
        let value = userDefaults.string(forKey: "Record")
        
        if value==nil {
             highScoreIntC.text = "0"
        }
        else {
            highScoreIntC.text = value
        }
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func StartBtnPressed(_ sender: Any) {
        
        //play tick sound
        AudioServicesPlaySystemSound(SystemSoundID(1104))
        
    }
    

}

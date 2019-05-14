//
//  EndViewController.swift
//  BOP_IT_APP
//
//  Created by Shivam smasher on 2018-03-07.
//  Copyright © 2018 Shivam Mahendru. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class EndViewController: UIViewController {

    
    //vars
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var restartBtnUNC: UIButton!
    
    var scoreData:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //round the corners
        //rounding the corners
        
        restartBtnUNC.layer.cornerRadius = 10.0
        
        label2.text = scoreData
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func restrartGamePressed(_ sender: Any) {
        //feedback sound
        AudioServicesPlaySystemSound(SystemSoundID(1104))
        
        self.dismiss(animated: false, completion: nil)
        self.presentingViewController?.dismiss(animated: false, completion: nil)
        
    }
    
}

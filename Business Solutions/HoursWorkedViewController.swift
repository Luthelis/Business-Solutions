//
//  HoursWorkedViewController.swift
//  Business Solutions
//
//  Created by Timothy Transue on 7/29/15.
//  Copyright © 2015 Timothy Transue. All rights reserved.
//

import UIKit

class HoursWorkedViewController: UIViewController {

    @IBOutlet weak var timeDisplay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func beginTimer(sender: UIButton)
    {
        if sender.titleLabel?.text == "Start"
        {
            sender.titleLabel?.text = "Break"
        }
        else if sender.titleLabel?.text == "Break"
        {
            
        }
        else if sender.titleLabel?.text == "Resume"
        {
            
        }
        else if sender.titleLabel?.text == "Stop"
        {
            
        }
    }

    func createTimer()
    {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

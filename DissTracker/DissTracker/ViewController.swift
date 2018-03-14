//
//  ViewController.swift
//  DissTracker
//
//  Created by Seth Kurkowski on 3/14/18.
//  Copyright © 2018 Seth Kurkowski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var servedTotal: UILabel!
    @IBOutlet weak var servedDaily: UILabel!
    @IBOutlet weak var servedMonthly: UILabel!
    @IBOutlet weak var servedYearly: UILabel!
    
    @IBOutlet weak var recievedTotal: UILabel!
    @IBOutlet weak var recievedDaily: UILabel!
    @IBOutlet weak var recievedMonthly: UILabel!
    @IBOutlet weak var recievedYearly: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        servedTotal.text = "Total\n0"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func DissServed(_ sender: UIButton) {
    }
    
    @IBAction func DissRecieved(_ sender: UIButton) {
    }
}


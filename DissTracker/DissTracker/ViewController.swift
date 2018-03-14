//
//  ViewController.swift
//  DissTracker
//
//  Created by Seth Kurkowski on 3/14/18.
//  Copyright © 2018 Seth Kurkowski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //IBOutlets - served
    @IBOutlet weak var servedTotal: UILabel!
    @IBOutlet weak var servedDaily: UILabel!
    @IBOutlet weak var servedMonthly: UILabel!
    @IBOutlet weak var servedYearly: UILabel!
    @IBOutlet weak var servedTotal_NUM: UILabel!
    @IBOutlet weak var servedDaily_NUM: UILabel!
    @IBOutlet weak var servedMonthly_NUM: UILabel!
    @IBOutlet weak var servedYearly_NUM: UILabel!
    //IBOutlets - received
    @IBOutlet weak var recievedTotal: UILabel!
    @IBOutlet weak var recievedDaily: UILabel!
    @IBOutlet weak var recievedMonthly: UILabel!
    @IBOutlet weak var recievedYearly: UILabel!
    @IBOutlet weak var receivedTotal_NUM: UILabel!
    @IBOutlet weak var receivedDaily_NUM: UILabel!
    @IBOutlet weak var receivedMonthly_NUM: UILabel!
    @IBOutlet weak var receivedYearly_NUM: UILabel!
    
    //Member variables
    let staticStrings = strings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        updateServedHeader()
    }
    
    func updateServedHeader() {
        if let totalServed = UserDefaults.standard.object(forKey: staticStrings.total_disses_served) as? Int {
            servedTotal_NUM.text = totalServed.description
            servedDaily_NUM.text = (totalServed / 365).description
            servedMonthly_NUM.text = (totalServed / 30).description
            servedYearly_NUM.text = ((totalServed / 30) * 12).description
        }
    }
    
    func updateReceivedHeader() {
        if let totalReceived = UserDefaults.standard.object(forKey: staticStrings.total_disses_recieved) as? Int {
            receivedTotal_NUM.text = totalReceived.description
            receivedDaily_NUM.text = (totalReceived / 365).description
            receivedMonthly_NUM.text = (totalReceived / 30).description
            receivedYearly_NUM.text = ((totalReceived / 30) * 12).description
        }
    }

    @IBAction func DissServed(_ sender: UIButton) {
        if let totalServed = UserDefaults.standard.object(forKey: staticStrings.total_disses_served) as? Int {
            let newTotal = totalServed + 1
            UserDefaults.standard.set(newTotal, forKey: staticStrings.total_disses_served)
        } else {
            UserDefaults.standard.set(1, forKey: staticStrings.total_disses_served)
        }
        updateServedHeader()
    }
    
    @IBAction func DissRecieved(_ sender: UIButton) {
        if let totalReceived = UserDefaults.standard.object(forKey: staticStrings.total_disses_recieved) as? Int {
            let newTotal = totalReceived + 1
            UserDefaults.standard.set(newTotal, forKey: staticStrings.total_disses_recieved)
        } else {
            UserDefaults.standard.set(1, forKey: staticStrings.total_disses_recieved)
        }
        updateReceivedHeader()
    }
}


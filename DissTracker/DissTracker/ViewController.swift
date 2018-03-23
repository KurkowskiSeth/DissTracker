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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let currentDateString = "12.03.2018"//dateFormatter.string(from: date)
        print(currentDateString)
        
        if (UserDefaults.standard.string(forKey: StaticStrings.download_date)) == nil {
            UserDefaults.standard.set(currentDateString, forKey: StaticStrings.download_date)
        }
        if let downloadDateString = UserDefaults.standard.string(forKey: StaticStrings.download_date) {
            let downloadDate = dateFormatter.date(from: downloadDateString)
            let currentDate = dateFormatter.date(from: currentDateString)
            
            let calendar = Calendar.current
            let dayDiff = calendar.dateComponents([.day], from: currentDate!, to: downloadDate!).day
            print(dayDiff!.description)
            if dayDiff! >= 0 {
                UserDefaults.standard.set(dayDiff, forKey: StaticStrings.total_days_since_download)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateServedHeader()
        updateReceivedHeader()
    }
    
    func updateServedHeader() {
        if let totalServed = UserDefaults.standard.object(forKey: StaticStrings.total_disses_served) as? Float, let totalDays = UserDefaults.standard.object(forKey: StaticStrings.total_days_since_download) as? Float {
            var totalDaysToDivideWith = totalDays
            if totalDays == 0 {
                totalDaysToDivideWith = 1
            }
            
            servedTotal_NUM.text = String(format: "%.0f", totalServed)
            servedDaily_NUM.text = String(format: "%.2f", (totalServed / totalDaysToDivideWith))
            servedMonthly_NUM.text = String(format: "%.2f", (totalServed / totalDaysToDivideWith) * 30)
            servedYearly_NUM.text = String(format: "%.2f", (totalServed / totalDaysToDivideWith) * 365)
        }
    }
    
    func updateReceivedHeader() {
        if let totalReceived = UserDefaults.standard.object(forKey: StaticStrings.total_disses_recieved) as? Float, let totalDays = UserDefaults.standard.object(forKey: StaticStrings.total_days_since_download) as? Float {
            var totalDaysToDivideWith = totalDays
            if totalDays == 0 {
                totalDaysToDivideWith = 1
            }
            
            receivedTotal_NUM.text = String(format: "%.0f", totalReceived)
            receivedDaily_NUM.text = String(format: "%.2f", (totalReceived / totalDaysToDivideWith))
            receivedMonthly_NUM.text = String(format:"%.2f", (totalReceived / totalDaysToDivideWith) * 30)
            receivedYearly_NUM.text = String(format:"%.2f", (totalReceived / totalDaysToDivideWith) * 365)
        }
    }

    @IBAction func DissServed(_ sender: UIButton) {
        if let totalServed = UserDefaults.standard.object(forKey: StaticStrings.total_disses_served) as? Int {
            let newTotal = totalServed + 1
            UserDefaults.standard.set(newTotal, forKey: StaticStrings.total_disses_served)
        } else {
            UserDefaults.standard.set(1, forKey: StaticStrings.total_disses_served)
        }
        updateServedHeader()
    }
    
    @IBAction func DissRecieved(_ sender: UIButton) {
        if let totalReceived = UserDefaults.standard.object(forKey: StaticStrings.total_disses_recieved) as? Int {
            let newTotal = totalReceived + 1
            UserDefaults.standard.set(newTotal, forKey: StaticStrings.total_disses_recieved)
        } else {
            UserDefaults.standard.set(1, forKey: StaticStrings.total_disses_recieved)
        }
        updateReceivedHeader()
    }
}


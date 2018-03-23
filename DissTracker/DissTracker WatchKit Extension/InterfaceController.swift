//
//  InterfaceController.swift
//  DissTracker WatchKit Extension
//
//  Created by Seth Kurkowski on 3/14/18.
//  Copyright © 2018 Seth Kurkowski. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @available(watchOS 2.2, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
    }
    //IBOutlets
    // Page 1
    @IBOutlet var totalServedLbl: WKInterfaceLabel!
    
    @IBOutlet var totalReceivedLbl: WKInterfaceLabel!
    
    @IBOutlet var avgServedDailyLbl: WKInterfaceLabel!
    @IBOutlet var avgServedMonthlyLbl: WKInterfaceLabel!
    @IBOutlet var avgServedYearlyLbl: WKInterfaceLabel!
    
    @IBOutlet var avgReceivedDailyLbl: WKInterfaceLabel!
    @IBOutlet var avgReceivedMonthlyLbl: WKInterfaceLabel!
    @IBOutlet var avgReceivedYearlyLbl: WKInterfaceLabel!
    
    @IBOutlet var dissServedBtn: WKInterfaceButton!
    @IBOutlet var dissReceivedBtn: WKInterfaceButton!
    
    let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    var dataPackage: WatchDataPackage?
    
    var totalServed = 0
    var totalReceived = 0
    var totalDaysSinceDownload = 1
    
    override init() {
        super.init()
        
        session?.delegate = self
        session?.activate()
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        //Get current date
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let currentDate = dateFormatter.string(from: date)
        print(currentDate)
        
        //Get user defaults from phone
        let packageMessage: [String: Any] = [StaticStrings.wcsession_msg_name_to_watch: true]
        if let session = session, session.isReachable {
            session.sendMessage(packageMessage, replyHandler: { (replyData) in
                DispatchQueue.main.async {
                    if let data = replyData[StaticStrings.watch_kit_package] as? Data {
                        NSKeyedUnarchiver.setClass(WatchDataPackage.self, forClassName: StaticStrings.archiever_class_name)
                        if let package = NSKeyedUnarchiver.unarchiveObject(with: data) as? WatchDataPackage {
                            //Set Member variables
                            self.dataPackage = package
                            self.totalServed = (self.dataPackage?.mTotalServed)!
                            self.totalReceived = (self.dataPackage?.mTotalReceived)!
                            self.totalDaysSinceDownload = (self.dataPackage?.mTotalDays)!
                            
                            //Set UI if available
                            if self.totalServedLbl != nil {
                                self.totalServedLbl.setText(self.dataPackage?.mTotalServed?.description)
                                self.dissServedBtn.setEnabled(true)
                                self.setServedAverages()
                            }
                            
                            if self.totalReceivedLbl != nil {
                                self.totalReceivedLbl.setText(self.dataPackage?.mTotalReceived?.description)
                                self.dissReceivedBtn.setEnabled(true)
                                self.setReceivedAverages()
                            }
                        }
                    }
                }
            }, errorHandler: nil)
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func addDissServed() {
        WKInterfaceDevice.current().play(.click)
        totalServed += 1
        totalServedLbl.setText(totalServed.description)
        saveToPhone()
        setServedAverages()
    }
    
    @IBAction func addDissReceived() {
        WKInterfaceDevice.current().play(.click)
        totalReceived += 1
        totalReceivedLbl.setText(totalReceived.description)
        saveToPhone()
        setReceivedAverages()
    }
    
    func saveToPhone() {
        let saveMessage: [String : Any] = [StaticStrings.wcsession_msg_name_to_phone: true, StaticStrings.total_disses_recieved: totalReceived, StaticStrings.total_disses_served: totalServed]
        if let session = session, session.isReachable {
            session.sendMessage(saveMessage, replyHandler: nil, errorHandler: nil)
        }
    }
    
    func setServedAverages() {
        let avgDaily = Float(totalServed) / Float(totalDaysSinceDownload)
        if avgServedDailyLbl != nil {
            avgServedDailyLbl.setText(String(format: "%.2f", avgDaily))
        }
        if avgServedMonthlyLbl != nil {
            avgServedMonthlyLbl.setText(String(format: "%.2f", avgDaily * 30))
        }
        if avgServedYearlyLbl != nil {
            avgServedYearlyLbl.setText(String(format: "%.2f", avgDaily * 365))
        }
    }
    
    func setReceivedAverages() {
        let avgDaily = Float(totalReceived) / Float(totalDaysSinceDownload)
        if avgReceivedDailyLbl != nil {
            avgReceivedDailyLbl.setText(String(format: "%.2f", avgDaily))
        }
        if avgReceivedMonthlyLbl != nil {
            avgReceivedMonthlyLbl.setText(String(format: "%.2f", avgDaily * 30))
        }
        if avgReceivedYearlyLbl != nil {
            avgReceivedYearlyLbl.setText(String(format: "%.2f", avgDaily * 365))
        }
    }
}

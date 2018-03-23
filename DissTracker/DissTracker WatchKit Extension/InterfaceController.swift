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
    
    @IBOutlet var totalServedLbl: WKInterfaceLabel!
    @IBOutlet var totalReceivedLbl: WKInterfaceLabel!
    
    let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    var dataPackage: WatchDataPackage?
    
    override init() {
        super.init()
        
        session?.delegate = self
        session?.activate()
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        if let totalServed = UserDefaults.standard.object(forKey: StaticStrings.total_disses_served) as? Int {
            print(totalServed.description)
            totalServedLbl.setText(totalServed.description)
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        let packageMessage: [String: Any] = [StaticStrings.wcsession_message_name: true]
        if let session = session, session.isReachable {
            session.sendMessage(packageMessage, replyHandler: { (replyData) in
                DispatchQueue.main.async {
                    if let data = replyData[StaticStrings.watch_kit_package] as? Data {
                        NSKeyedUnarchiver.setClass(WatchDataPackage.self, forClassName: StaticStrings.archiever_class_name)
                        if let package = NSKeyedUnarchiver.unarchiveObject(with: data) as? WatchDataPackage {
                            self.dataPackage = package
                            if (self.totalServedLbl != nil) {
                                self.totalServedLbl.setText(self.dataPackage?.mTotalServed?.description)
                            }
                            if (self.totalReceivedLbl != nil) {
                                self.totalReceivedLbl.setText(self.dataPackage?.mTotalReceived?.description)
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

}

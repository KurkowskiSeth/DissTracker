//
//  InterfaceController.swift
//  DissTracker WatchKit Extension
//
//  Created by Seth Kurkowski on 3/14/18.
//  Copyright © 2018 Seth Kurkowski. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet var totalServedLbl: WKInterfaceLabel!
    let staticStrings = strings()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        if let totalServed = UserDefaults.standard.object(forKey: staticStrings.total_disses_served) as? Int {
            print(totalServed.description)
            totalServedLbl.setText(totalServed.description)
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

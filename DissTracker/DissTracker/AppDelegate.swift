//
//  AppDelegate.swift
//  DissTracker
//
//  Created by Seth Kurkowski on 3/14/18.
//  Copyright © 2018 Seth Kurkowski. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var session: WCSession? {
        didSet{
            if let session = session {
                session.delegate = self
                session.activate()
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if WCSession.isSupported() {
            session = WCSession.default
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate: WCSessionDelegate {
    func sessionDidDeactivate(_ session: WCSession) {
    }
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async {
            if (message[StaticStrings.wcsession_msg_name_to_watch] as? Bool) != nil {
                //Get totals
                let totalDissesReceived = UserDefaults.standard.integer(forKey: StaticStrings.total_disses_recieved)
                let totalDissesServed = UserDefaults.standard.integer(forKey: StaticStrings.total_disses_served)
                
                //Get number of days for averages
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                
                //MARK: -Switch this variables to check averages
//                let currentDateString = dateFormatter.string(from: date)
                let currentDateString = "12.03.2018"
                
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
                let totalDaysSinceDownload = UserDefaults.standard.integer(forKey: StaticStrings.total_days_since_download)
                
                //Get data ready to be sent
                let package = WatchDataPackage(_totalReceived: totalDissesReceived, _totalServed: totalDissesServed, _totalDays: totalDaysSinceDownload)
                NSKeyedArchiver.setClassName(StaticStrings.archiever_class_name, for: WatchDataPackage.self)
                let data = NSKeyedArchiver.archivedData(withRootObject: package)
                
                //Send data package
                replyHandler([StaticStrings.watch_kit_package: data])
                
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if (message[StaticStrings.wcsession_msg_name_to_phone] as? Bool) != nil {
                if let newTotalServed = message[StaticStrings.total_disses_served] as? Int {
                    UserDefaults.standard.set(newTotalServed, forKey: StaticStrings.total_disses_served)
                }
                if let newTotalReceived = message[StaticStrings.total_disses_recieved] as? Int {
                    UserDefaults.standard.set(newTotalReceived, forKey: StaticStrings.total_disses_recieved)
                }
            }
        }
    }
}


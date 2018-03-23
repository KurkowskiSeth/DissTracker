//
//  WatchDataPackage.swift
//  DissTracker
//
//  Created by Seth Kurkowski on 3/22/18.
//  Copyright © 2018 Seth Kurkowski. All rights reserved.
//

import Foundation
class WatchDataPackage: NSObject, NSCoding {

    var mTotalReceived: Int?
    var mTotalServed: Int?
//    var mTotalDays: Int?

    init(_totalReceived: Int, _totalServed: Int){//}, _totalDays: Int) {
        mTotalReceived = _totalReceived
        mTotalServed = _totalServed
//        mTotalDays = _totalDays
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(_totalReceived: 0, _totalServed: 0)//, _totalDays: 0)

        mTotalReceived = aDecoder.decodeObject(forKey: StaticStrings.total_disses_recieved) as? Int
        mTotalServed = aDecoder.decodeObject(forKey: StaticStrings.total_disses_served) as? Int
//        mTotalDays = aDecoder.decodeObject(forKey: StaticStrings.total_days_since_download) as? Int
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(mTotalReceived, forKey: StaticStrings.total_disses_recieved)
        aCoder.encode(mTotalServed, forKey: StaticStrings.total_disses_served)
//        aCoder.encode(mTotalDays, forKey: StaticStrings.total_days_since_download)
    }
}


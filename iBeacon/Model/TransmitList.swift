//
//  TransmitList.swift
//  iBeacon
//
//  Created by GENKIFUJIMOTO on 2022/11/14.
//

import Foundation
import RealmSwift

class TrasmitList: Object {
    
    @objc dynamic var UUID = ""
    @objc dynamic var addName = ""
    @objc dynamic var major = ""
    @objc dynamic var miner = ""
    
    //　ユニークキーの設定
    override static func primaryKey() -> String? {
        return "addName"
    }
}

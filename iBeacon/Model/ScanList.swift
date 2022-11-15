//
//  ScanUUID.swift
//  iBeacon
//
//  Created by GENKIFUJIMOTO on 2022/11/11.
//

import Foundation
import RealmSwift

class ScanList: Object {
    
    @objc dynamic var UUID = ""
    @objc dynamic var addName = ""
    
    //　ユニークキーの設定
    override static func primaryKey() -> String? {
        return "UUID"
    }
}

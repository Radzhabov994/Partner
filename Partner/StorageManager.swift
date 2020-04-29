//
//  StorageManager.swift
//  Partner
//
//  Created by Гамид Раджабов on 25.04.2020.
//  Copyright © 2020 Gamid Radzhabov. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ partner: Partner){
        
        try! realm.write {
            realm.add(partner)
        }
    }
    
    static func deleteObject(_ partner: Partner){
        
        try! realm.write {
            realm.delete(partner)
        }
    }
}

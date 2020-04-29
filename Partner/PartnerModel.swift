//
//  PartnerModel.swift
//  Partner
//
//  Created by Гамид Раджабов on 22.11.2019.
//  Copyright © 2019 Gamid Radzhabov. All rights reserved.
//

import RealmSwift

class Partner: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var type: String?
    @objc dynamic var location: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var date = Date()
    
    convenience init(name: String, location: String?, type: String?, imageData: Data?){
        self.init()
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
    }
    
}

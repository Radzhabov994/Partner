//
//  PartnerModel.swift
//  Partner
//
//  Created by Гамид Раджабов on 22.11.2019.
//  Copyright © 2019 Gamid Radzhabov. All rights reserved.
//

import Foundation

struct Partner {
    
    var name: String
    var type: String
    var location: String
    var image: String
    
    static let partners = ["Yandex", "Vkontakte", "Mail.ru", "Avito", "Telegram"]
    
    static func getPartners() -> [Partner]{
        
        var bpartners = [Partner]()
        
        for partner in partners {
            bpartners.append(Partner(name: partner, type: "IT", location: "Moscow", image: partner))
        }
        
        return bpartners
    }
}

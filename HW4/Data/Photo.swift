//
//  Photo.swift
//  homeW1-2
//
//  Created by Давид Горзолия on 06.01.2021.
//


import Foundation
import SwiftyJSON
import RealmSwift

class Photo: Object, Codable {
    override var description: String {
        return "\(id) \(url) \(owner_id)"
    }
        
    @objc dynamic var id = 0
    @objc dynamic var url = ""
    @objc dynamic var owner_id = ""
    
    required convenience init(json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        self.url = json["sizes"][3]["url"].stringValue
        self.owner_id = json["owner_id"].stringValue
    }
}

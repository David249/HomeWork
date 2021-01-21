//
//  Photo.swift
//  homeW1-2
//
//  Created by Давид Горзолия on 06.01.2021.
//


import Foundation
import SwiftyJSON
import RealmSwift

class Photo: Object {
        
    @objc dynamic var id = 0
    @objc dynamic var url = ""
    var owner = LinkingObjects(fromType: User.self, property: "photos")
    
    required convenience init(json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        self.url = json["sizes"][3]["url"].stringValue
//        self.owner_id = json["owner_id"].stringValue
    }
    
    override static func primaryKey() -> String {
        return "id"
    }
}

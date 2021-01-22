//
//  Group.swift
//  homeW1-2
//
//  Created by Давид Горзолия on 06.01.2021.
//
import Foundation
import SwiftyJSON
import RealmSwift

class Group: Object, Decodable {
   
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var photo = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case photo
    }
    
    required convenience init(json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.photo = json["photo_200"].stringValue
    }
    
    override static func primaryKey() -> String {
        return "id"
    }
}

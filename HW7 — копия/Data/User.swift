//
//  User.swift
//  homeW1-2
//
//  Created by Давид Горзолия on 06.01.2021.
//


import Foundation
import SwiftyJSON
import RealmSwift

class User: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var first_name = ""
    @objc dynamic var last_name = ""
    @objc dynamic var avatar = ""
    var photos = List<Photo>()
    
    required convenience init(json: JSON, photos: [Photo] = []) {
        self.init()
        
        self.id = json["id"].intValue
        self.first_name = json["first_name"].stringValue
        self.last_name = json["last_name"].stringValue
        self.avatar = json["photo_200_orig"].stringValue
        self.photos.append(objectsIn: photos)
    }
    
    override static func primaryKey() -> String {
        return "id"
    }
}

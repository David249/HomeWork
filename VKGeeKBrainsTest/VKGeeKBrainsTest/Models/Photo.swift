//
//  Photo.swift
//  VKGeeKBrainsTest
//
//  Created by Давид Горзолия on 31.01.2021.
//

import UIKit
import RealmSwift

class Photo: Object {
    @objc dynamic var photo: String = ""
    @objc dynamic var ownerID: String  = ""
    
    init(photo: String, ownerID: String) {
        self.photo = photo
        self.ownerID = ownerID
    }
    
    // этот инит обязателен для Object
    required override init() {
        super.init()
    }
}

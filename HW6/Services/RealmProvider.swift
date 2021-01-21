//
//  RealmProvider.swift
//  homeW1-2
//
//  Created by Давид Горзолия on 21.01.2021.
//

import RealmSwift

class RealmProvider {
    static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    static func save<T: Object>(items: [T],
                                config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true),
                                update: Bool = true) {
        print(config.fileURL!)
        
        do {
            let realm = try Realm(configuration: self.deleteIfMigration)
            
            try realm.write {
                realm.add(items, update: .all)
            }
            
        } catch {
            print(error)
        }
    }
    
    static func get<T: Object>(_ type: T.Type,
                               config: Realm.Configuration = Realm.Configuration.defaultConfiguration) -> Results<T>? {
        do {
            let realm = try Realm(configuration: self.deleteIfMigration)
            return realm.objects(type)
        } catch {
            print(error)
        }
        return nil
    }
    
    
}

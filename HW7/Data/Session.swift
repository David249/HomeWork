//
//  Session.swift
//  homeW1-2
//
//  Created by Давид Горзолия on 24.12.2020.
//


import Foundation

class Session {
    
    static let shared = Session()
    
    var token: String = ""
    var userId: Int = 0
    
    private init() {}
    
}

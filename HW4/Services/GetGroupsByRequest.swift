//
//  GetGroupsByRequest.swift
//  homeW1-2
//
//  Created by Давид Горзолия on 06.01.2021.
//


import Foundation
import Alamofire

protocol GetGroupsByRequestDelegate: class {
    func searchGroup(query: String)
}

class GetGroupsByRequest {
    
    public weak var delegate: GetGroupsByRequestDelegate?
    
//    static func sendRequest(query: String) {
//
//
//    }
    
    public func searchGroup(query: String) {
        let baseUrl = Data.baseUrl
        let path = "/method/groups.search"
        let url = baseUrl+path
        
        let parameters: Parameters = [
            "access_token": Session.shared.token,
            "q": query,
            "v": Data.versionAPI
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            
            guard let value = response.value else { return }
            print("Список групп по запросу \"\(query)\":", value)
            
//            guard let value = response.value else { return }
//            print("Список групп по запросу \"\(query)\":")
        }
    }
}

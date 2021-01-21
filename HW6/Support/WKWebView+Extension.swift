//
//  WKWebView+Extension.swift
//  homeW1-2
//
//  Created by Давид Горзолия on 06.01.2021.
//
import Foundation
import WebKit

extension WKWebView {
    
    func cleanAllCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
//        print("All cookies deleted")
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
//                print("Cookie ::: \(record) deleted")
            }
        }
    }
    
    func refreshCookies() {
        self.configuration.processPool = WKProcessPool()
    }
}

//
//  DataManager.swift
//  iNews
//
//  Created by Volodymyr on 7/27/18.
//  Copyright © 2018 Volodymyr. All rights reserved.
//

import Foundation
import UIKit

enum NewsData: String {
    case baseUrl = "https://newsapi.org/v2/top-headlines?"
    case country = "us"
    case apiKey = "5505ed68f5c4444c88b0a06bee0ebc29"
}

class DataManager {

    static let dataManager = DataManager()
    var newsArray = [Articles]()
    var currentNewsArray = [Articles]()

    func getUrl(baseUrl: String, country: String, apiKey: String) -> String {
        let url = baseUrl + "country=" + country + "&" + "apiKey=" + apiKey
        return url
    }

    //MARK:- getCurrentArray()
    func getCurrentArray(array: [Articles]) -> [Articles] {
        let filteredArray = array
        for item in filteredArray {
            if item.description != nil {
//                filteredArray.sorted {
//                    UIContentSizeCategory(rawValue: $0.publishedAt!) > UIContentSizeCategory(rawValue: $1.publishedAt!)
//                }
            } else {
                continue
            }
            print(item.publishedAt)
        }
        return filteredArray
    }

}

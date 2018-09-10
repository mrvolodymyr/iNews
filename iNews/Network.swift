//
//  Network.swift
//  iNews
//
//  Created by Volodymyr on 8/2/18.
//  Copyright © 2018 Volodymyr. All rights reserved.
//

import Foundation
import UIKit

let dataManager = DataManager.dataManager

class Network {

    static let network = Network()

    func getNews() {

        guard let url = URL(string: dataManager.getUrl(baseUrl: NewsData.baseUrl.rawValue,
                                                       country: NewsData.country.rawValue,
                                                       apiKey: NewsData.apiKey.rawValue)) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, response != nil , error == nil else { return }
            do {
                let json = try JSONDecoder().decode(News.self, from: data)
                guard let news = json.articles as? [Articles] else { return }
                DispatchQueue.main.async {
                    DataManager.dataManager.newsArray = news
                }
            } catch let error {
                print(error)
            }
            }.resume()
    }
}

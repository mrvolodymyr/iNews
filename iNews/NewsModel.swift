//
//  NewsModel.swift
//  iNews
//
//  Created by Volodymyr on 7/27/18.
//  Copyright © 2018 Volodymyr. All rights reserved.
//

import Foundation
import UIKit

struct News: Decodable {
    var status: String?
    var totalResults: Int?
    var articles: [Articles?]
}

struct Articles: Decodable {
    var source: Source?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
}

struct Source: Decodable {
    var id: String?
    var name: String?
}

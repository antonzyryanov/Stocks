//
//  StocksModel.swift
//  Stocks
//
//  Created by Anton Zyryanov on 21.07.2025.
//

import Foundation

struct StocksModel: Codable {
    let symbol, name: String
    let price, change, changePercent: Double
    let logo: String
    var isFavourite: Bool?
    var presentationPrice, presentationPriceDynamic: String?
}

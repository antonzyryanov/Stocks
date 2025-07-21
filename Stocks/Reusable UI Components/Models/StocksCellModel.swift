//
//  StocksCellModel.swift
//  Stocks
//
//  Created by Anton Zyryanov on 21.07.2025.
//

import Foundation

struct StocksCellModel {
    var data: StocksModel
    var topLeftLabelModel: CustomLabelModel
    var bottomLeftLabelModel: CustomLabelModel
    var topRightLabelModel: CustomLabelModel
    var bottomRightLabelModel: CustomLabelModel
    var favoriteImageName: String
    var notFavoriteImageName: String
    var itemIndex: Int
}

//
//  LocalStocksDataRepositoryProtocol.swift
//  Stocks
//
//  Created by Anton Zyryanov on 21.07.2025.
//

import Foundation

protocol LocalStocksDataRepositoryProtocol {
    func save(stocks: [StocksModel])
    func updateFavouriteStatusOf(stock: StocksModel)
    func fetchStocks(completion: @escaping ([StocksModel])->Void)
}

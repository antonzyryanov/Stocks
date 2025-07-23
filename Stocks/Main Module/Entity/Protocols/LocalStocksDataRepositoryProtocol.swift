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
    func fetchHistoryPrompts(completion: @escaping (PromptsModel?) -> Void)
    func saveHistory(prompts: PromptsModel)
    func fetchPopularPrompts(completion: @escaping (PromptsModel?) -> Void)
    func savePopular(prompts: PromptsModel)
}

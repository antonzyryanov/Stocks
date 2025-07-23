//
//  StonksDataRepositoryProtocol.swift
//  Stocks
//
//  Created by Anton Zyryanov on 21.07.2025.
//

import Foundation

protocol StocksDataRepositoryProtocol {
    func fetchStocks(completion: @escaping ([StocksModel])->Void)
    func fetchPrompts(completion: @escaping (PromptsModel,PromptsModel) -> Void)
    func save(stocks: [StocksModel])
    func saveHistory(prompts: PromptsModel)
    func updateFavouriteStatusOf(stock: StocksModel)
}

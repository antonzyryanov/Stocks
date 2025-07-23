//
//  StocksDataRepositoryImpl.swift
//  Stocks
//
//  Created by Anton Zyryanov on 21.07.2025.
//

import Foundation

class StocksDataRepositoryImpl: StocksDataRepositoryProtocol {
   
    private var localStocksDataRepository: LocalStocksDataRepositoryProtocol = LocalStocksDataRepositoryImpl()
    private var networkStocksDataRepository: NetworkStocksDataRepositoryProtocol = NetworkStocksDataRepositoryImpl()
    
    private var stocks: [StocksModel] = []
    
    func fetchStocks(completion: @escaping ([StocksModel]) -> Void) {
        var localStocks: [StocksModel] = []
        var networkStocks: [StocksModel] = []

        let group = DispatchGroup()
        group.enter()
            DispatchQueue.global().async {
                self.localStocksDataRepository.fetchStocks { stocks in
                    localStocks = stocks
                    group.leave()
                }
        }

        group.enter()
        DispatchQueue.global().async {
            self.networkStocksDataRepository.fetchStocks { stocks in
                networkStocks = stocks
                group.leave()
            }
            
        }

        group.notify(queue: .main) {
            if localStocks.isEmpty {
                self.stocks = networkStocks
            } else {
                for (index,parsedStock) in networkStocks.enumerated() {
                    for localStock in localStocks {
                        if localStock.name == parsedStock.name {
                            networkStocks[index].isFavourite = localStock.isFavourite
                            break
                        }
                    }
                }
                self.stocks = networkStocks
            }
            self.localStocksDataRepository.save(stocks: networkStocks)
            DispatchQueue.main.async {
                completion(self.stocks)
            }
        }
        
    }
    
    func fetchPrompts(completion: @escaping (PromptsModel,PromptsModel) -> Void) {
        var popularPrompts: PromptsModel = PromptsModel(items: [])
        var historyPrompts: PromptsModel = PromptsModel(items: [])

        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global().async {
            self.localStocksDataRepository.fetchPopularPrompts { fethcedPrompts in
                if fethcedPrompts?.items.isEmpty ?? true {
                    popularPrompts = .init(items: ["Apple", "First Solar", "Amazon", "Alibaba", "Google", "Facebook", "Tesla", "Microsoft", "Mastercard"])
                    self.localStocksDataRepository.savePopular(prompts: popularPrompts)
                } else {
                    popularPrompts = fethcedPrompts ?? .init(items: [])
                }
                group.leave()
            }
        }
        
        group.enter()
        DispatchQueue.global().async {
            self.localStocksDataRepository.fetchHistoryPrompts { fethcedPrompts in
                if fethcedPrompts?.items.isEmpty ?? false {
                    historyPrompts = .init(items: [""])
                } else {
                    historyPrompts = fethcedPrompts ?? .init(items: [])
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(popularPrompts,historyPrompts)
        }
        
    }
        
    func save(stocks: [StocksModel]) {
        localStocksDataRepository.save(stocks: stocks)
    }
    
    func saveHistory(prompts: PromptsModel) {
        localStocksDataRepository.saveHistory(prompts: prompts)
    }
    
    func updateFavouriteStatusOf(stock: StocksModel) {
        localStocksDataRepository.updateFavouriteStatusOf(stock: stock)
    }
    
}

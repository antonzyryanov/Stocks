//
//  StocksInteractor.swift
//  Stocks
//
//  Created by Anton Zyryanov on 20.07.2025.
//  
//

import Foundation

class StocksInteractor: PresenterToInteractorStocksProtocol {
    
    var dataRepostory: StocksDataRepositoryProtocol?
    
    func handlePresentersRequestUpdate() {
        
        var presentationModel: StocksModulePresentationModel = .init(stocks: [],popularPrompts: PromptsModel(items: []),historyPrompts: PromptsModel(items: []))
        
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().async {
            self.dataRepostory?.fetchStocks { fetchedStocks in
                presentationModel.stocks = fetchedStocks
                group.leave()
            }
        }
    
        group.enter()
        DispatchQueue.global().async {
            self.dataRepostory?.fetchPrompts { fetchedPopularPrompts, fetchedHistoryPrompts in
                presentationModel.popularPrompts = fetchedPopularPrompts
                presentationModel.historyPrompts = fetchedHistoryPrompts
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.presenter?.handleUpdateOf(presentationModel: presentationModel)
        }
        
    }
    
    func handleUpdateOfStock(presentationModel: StocksModel) {
        dataRepostory?.updateFavouriteStatusOf(stock: presentationModel)
    }
    
    func handleUpdateOfHistory(prompts: PromptsModel) {
        dataRepostory?.saveHistory(prompts: prompts)
    }

    var presenter: InteractorToPresenterStocksProtocol?
}

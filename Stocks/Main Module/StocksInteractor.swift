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
        dataRepostory?.fetchStocks { stocks in
            self.presenter?.handleUpdateOf(stocks: stocks)
        }
    }
    
    func handleUpdateOfStock(presentationModel: StocksModel) {
        dataRepostory?.updateFavouriteStatusOf(stock: presentationModel)
    }

    var presenter: InteractorToPresenterStocksProtocol?
}

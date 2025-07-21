//
//  StocksContract.swift
//  Stocks
//
//  Created by Anton Zyryanov on 20.07.2025.
//  
//

import Foundation


protocol PresenterToViewStocksProtocol {
    func handleUpdateOf(stocks: [StocksModel])
}


protocol ViewToPresenterStocksProtocol {
    
    func handleViewsRequestUpdate()
    func handleUpdateOfStock(presentationModel: StocksModel)
    
    var view: PresenterToViewStocksProtocol? { get set }
    var interactor: PresenterToInteractorStocksProtocol? { get set }
    var router: PresenterToRouterStocksProtocol? { get set }
}


protocol PresenterToInteractorStocksProtocol {
    
    func handlePresentersRequestUpdate()
    func handleUpdateOfStock(presentationModel: StocksModel)
    
    var presenter: InteractorToPresenterStocksProtocol? { get set }
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterStocksProtocol {
    func handleUpdateOf(stocks: [StocksModel])
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterStocksProtocol {
    
}

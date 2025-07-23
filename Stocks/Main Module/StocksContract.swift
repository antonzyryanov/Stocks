//
//  StocksContract.swift
//  Stocks
//
//  Created by Anton Zyryanov on 20.07.2025.
//  
//

import Foundation


protocol PresenterToViewStocksProtocol {
    func handleUpdateOf(presentationModel: StocksModulePresentationModel)
}


protocol ViewToPresenterStocksProtocol {
    
    func handleViewsRequestUpdate()
    func handleUpdateOfStock(presentationModel: StocksModel)
    func handleUpdateOfHistory(prompts: PromptsModel)
    
    var view: PresenterToViewStocksProtocol? { get set }
    var interactor: PresenterToInteractorStocksProtocol? { get set }
    var router: PresenterToRouterStocksProtocol? { get set }
}


protocol PresenterToInteractorStocksProtocol {
    
    func handlePresentersRequestUpdate()
    func handleUpdateOfStock(presentationModel: StocksModel)
    func handleUpdateOfHistory(prompts: PromptsModel)
    
    var presenter: InteractorToPresenterStocksProtocol? { get set }
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterStocksProtocol {
    func handleUpdateOf(presentationModel: StocksModulePresentationModel)
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterStocksProtocol {
    
}

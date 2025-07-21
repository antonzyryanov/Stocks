//
//  RoutersFactory.swift
//  Zeros Cantina
//
//  Created by Anton Zyryanov on 14.06.2025.
//

import Foundation

class ModulesFactoryImpl: ModulesFactoryProtocol {
    
    func createMainRouter() -> MainRouter {
        let mainRouter = MainRouter()
        return mainRouter
    }
    
    func createStocksModule(dataRepository: StocksDataRepositoryProtocol) -> StocksRouter {
        let stocksRouter = StocksRouter()
        stocksRouter.createModule(dataRepository: dataRepository)
        return stocksRouter
    }
    
    
}

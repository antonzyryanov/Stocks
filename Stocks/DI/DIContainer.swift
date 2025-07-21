//
//  DIContainer.swift
//  Zeros Cantina
//
//  Created by Anton Zyryanov on 14.06.2025.
//

import Foundation

class DIContainer: DIContainerProtocol {
    
    var modulesFactory: ModulesFactoryProtocol!
    
    var rootRouter: RouterProtocol
    
    let stocksDataRepository = StocksDataRepositoryImpl()
    
    init() {
        let factory = ModulesFactoryImpl()
        self.modulesFactory = factory
        self.rootRouter = factory.createMainRouter()
        let modulesRouters = self.createModules()
        setupRouterDependencies(routers: modulesRouters)
    }
    
    func createModules() -> [any RouterProtocol] {
        guard let modulesFactoryImpl = modulesFactory as? ModulesFactoryImpl,
              let mainRouter = rootRouter as? MainRouter else { return [] }
        var routers: [RouterProtocol] = []
        createStocksRouter(modulesFactoryImpl, &routers, mainRouter)
        return routers
    }
    
    private func createStocksRouter(_ modulesFactoryImpl: ModulesFactoryImpl, _ routers: inout [any RouterProtocol], _ mainRouter: MainRouter) {
        let stocksScreenRouter = modulesFactoryImpl.createStocksModule(dataRepository: stocksDataRepository)
        routers.append(stocksScreenRouter)
        stocksScreenRouter.mainRouter = mainRouter
    }
    
    func setupRouterDependencies(routers: [RouterProtocol]) {
        guard let mainRouter = rootRouter as? MainRouter else { return }
        mainRouter.setupDependencies(childRouters: routers)
        mainRouter.activate()
    }
        
}

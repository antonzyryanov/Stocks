//
//  DIContainerProtocol.swift
//  Zeros Cantina
//
//  Created by Anton Zyryanov on 14.06.2025.
//

import Foundation

protocol DIContainerProtocol {
    
    var rootRouter: RouterProtocol { get set }
    var modulesFactory: ModulesFactoryProtocol! { get set }
    
    func createModules() -> [RouterProtocol]
    func setupRouterDependencies(routers: [RouterProtocol])
    
}

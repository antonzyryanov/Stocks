//
//  MainRouter.swift
//  Zeros Cantina
//
//  Created by Anton Zyryanov on 14.06.2025.
//  
//

import Foundation
import UIKit

class MainRouter: MainRouterProtocol, RouterProtocol {
    
    
    var childRouters: [RouterProtocol] = []
    
    func activate() {
        show(screen: "Stocks")
    }
    
    func setupDependencies(childRouters: [RouterProtocol]) {
        self.childRouters = childRouters
    }
    
    func navigateTo(screen: String) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            self.show(screen: screen)
        }
    }
    
    func show(screen: String) {
        switch screen {
            case "Stocks":
                showStocksScreen()
            default:
                _ = "default"
        }
    }
    
    
    func showStocksScreen() {
        guard
        let stocksScreenRouter = childRouters[0] as? StocksRouter,
        let stocksVC = stocksScreenRouter.presenter.view as? StocksViewController,
        let currentWindow = UIApplication.shared.currentWindow
        else {
            print("[MainRouter] failed to show Stoks screen")
            return
        }
        currentWindow.rootViewController = stocksVC
    }
    
}

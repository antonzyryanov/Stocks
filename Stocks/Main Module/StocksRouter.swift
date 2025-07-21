//
//  StocksRouter.swift
//  Stocks
//
//  Created by Anton Zyryanov on 20.07.2025.
//  
//

import Foundation
import UIKit

class StocksRouter: PresenterToRouterStocksProtocol, RouterProtocol {
    
    weak var mainRouter: RouterProtocol? = nil
    
    func navigateTo(screen: String) {
        mainRouter?.navigateTo(screen: screen)
    }
    
    let presenter: ViewToPresenterStocksProtocol & InteractorToPresenterStocksProtocol = StocksPresenter()
    
    // MARK: Static methods
    func createModule(dataRepository:StocksDataRepositoryProtocol) -> UIViewController {
        let viewController = StocksViewController()
        viewController.presenter = self.presenter
        viewController.presenter?.router = self
        viewController.presenter?.router = StocksRouter()
        viewController.presenter?.view = viewController
        let interactor = StocksInteractor()
        interactor.dataRepostory = dataRepository
        viewController.presenter?.interactor = interactor
        viewController.presenter?.interactor?.presenter = presenter
        return viewController
    }
    
}

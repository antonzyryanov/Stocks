//
//  StocksPresenter.swift
//  Stocks
//
//  Created by Anton Zyryanov on 20.07.2025.
//  
//

import Foundation

class StocksPresenter: ViewToPresenterStocksProtocol {
    
    func handleViewsRequestUpdate() {
        interactor?.handlePresentersRequestUpdate()
    }
    
    func handleUpdateOfStock(presentationModel: StocksModel) {
        interactor?.handleUpdateOfStock(presentationModel: presentationModel)
    }

    // MARK: Properties
    var view: PresenterToViewStocksProtocol?
    var interactor: PresenterToInteractorStocksProtocol?
    var router: PresenterToRouterStocksProtocol?
}

extension StocksPresenter: InteractorToPresenterStocksProtocol {
    
    func handleUpdateOf(stocks: [StocksModel]) {
        let stocksWithoutNils = stocks.map { model in
            var presentaionPrice = ""
            var presentationPriceDynamic = ""
            let change = model.change
            if change > 0 {
                presentationPriceDynamic = "+$" + "\(change)" + " (\(abs(model.changePercent))%)"
            } else {
                presentationPriceDynamic = "-$" + "\(abs(change))" + " (\(abs(model.changePercent))%)"
            }
            let editedPrice = removeDigitsAfterCommaIfNeededFrom(price: model.price)
            presentaionPrice = "$" + editedPrice
            return StocksModel(symbol: model.symbol, name: model.name, price: model.price, change: model.change, changePercent: model.changePercent, logo: model.logo, isFavourite: model.isFavourite ?? false, presentationPrice: presentaionPrice, presentationPriceDynamic:presentationPriceDynamic)
        }
        view?.handleUpdateOf(stocks: stocksWithoutNils)
    }
    
    private func removeDigitsAfterCommaIfNeededFrom(price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: price)) ?? ""
    }
    
}

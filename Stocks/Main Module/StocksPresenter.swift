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
    
    func handleUpdateOfHistory(prompts: PromptsModel) {
        interactor?.handleUpdateOfHistory(prompts: prompts)
    }

    var view: PresenterToViewStocksProtocol?
    var interactor: PresenterToInteractorStocksProtocol?
    var router: PresenterToRouterStocksProtocol?
}

extension StocksPresenter: InteractorToPresenterStocksProtocol {
    
    func handleUpdateOf(presentationModel: StocksModulePresentationModel) {
        let formattedStocks = presentationModel.stocks.map { model in
            var presentaionPrice = ""
            var presentationPriceDynamic = ""
            formatData(model, &presentationPriceDynamic, &presentaionPrice)
            return StocksModel(symbol: model.symbol, name: model.name, price: model.price, change: model.change, changePercent: model.changePercent, logo: model.logo, isFavourite: model.isFavourite ?? false, presentationPrice: presentaionPrice, presentationPriceDynamic:presentationPriceDynamic)
        }
        
        let editedModel = StocksModulePresentationModel(stocks: formattedStocks, popularPrompts: presentationModel.popularPrompts, historyPrompts: presentationModel.historyPrompts)
        
        view?.handleUpdateOf(presentationModel: editedModel)
    }
    
    private func formatData(_ model: StocksModel, _ presentationPriceDynamic: inout String, _ presentaionPrice: inout String) {
        let change = model.change
        if change > 0 {
            presentationPriceDynamic = "+$" + "\(change)" + " (\(abs(model.changePercent))%)"
        } else {
            presentationPriceDynamic = "-$" + "\(abs(change))" + " (\(abs(model.changePercent))%)"
        }
        let editedPrice = removeDigitsAfterCommaIfNeededFrom(price: model.price)
        presentaionPrice = "$" + editedPrice
    }
    
    private func removeDigitsAfterCommaIfNeededFrom(price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: price)) ?? ""
    }
    
}

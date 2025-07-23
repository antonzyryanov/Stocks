//
//  StocksModulePresentationModel.swift
//  Stocks
//
//  Created by Anton Zyryanov on 22.07.2025.
//

import Foundation

struct StocksModulePresentationModel {
    var stocks: [StocksModel] = []
    var popularPrompts: PromptsModel = PromptsModel(items: [])
    var historyPrompts: PromptsModel = PromptsModel(items: [])
}

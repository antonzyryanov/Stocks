//
//  NetworkStocksDataRepositoryProtocol.swift
//  Stocks
//
//  Created by Anton Zyryanov on 21.07.2025.
//

import Foundation

protocol NetworkStocksDataRepositoryProtocol {
    func fetchStocks(completion: @escaping ([StocksModel])->Void)
}

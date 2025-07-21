//
//  NetworkStocksDataRepositoryImpl.swift
//  Stocks
//
//  Created by Anton Zyryanov on 21.07.2025.
//

import Foundation

class NetworkStocksDataRepositoryImpl: NetworkStocksDataRepositoryProtocol {
    
    func fetchStocks(completion: @escaping ([StocksModel])->Void) {
        guard let url = URL(string: "https://mustdev.ru/api/stocks.json") else {
            print("[NetworkStocksDataRepositoryImpl]: Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("[NetworkStocksDataRepositoryImpl]: Error fetching data: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("[NetworkStocksDataRepositoryImpl]: Invalid response or status code")
                return
            }
            
            guard let data = data else {
                print("[NetworkStocksDataRepositoryImpl]: No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let stocksArray = try decoder.decode(StocksModelsContainer.self, from: data)
                print("[NetworkStocksDataRepositoryImpl]: Stocks fetched successfully")
                DispatchQueue.main.async {
                    completion(stocksArray)
                }
            } catch {
                print("[NetworkStocksDataRepositoryImpl]: Decoding error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
}

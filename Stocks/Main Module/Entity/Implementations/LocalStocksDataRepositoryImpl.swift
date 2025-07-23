//
//  LocalStocksDataRepositoryImpl.swift
//  Stocks
//
//  Created by Anton Zyryanov on 21.07.2025.
//

import Foundation

import CoreData
import Foundation

class LocalStocksDataRepositoryImpl: NSObject, LocalStocksDataRepositoryProtocol {
    
    private let lock = NSLock()

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Stocks")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("[LocalStocksDataRepositoryImpl]: Core Data store failed: \(error)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func save(stocks: [StocksModel]) {
        lock.lock()
        defer { lock.unlock() }
        
        let context = self.context
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "StockEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("[LocalStocksDataRepositoryImpl]: Failed to delete existing data: \(error)")
        }
        
        for stock in stocks {
            let stockEntity = NSEntityDescription.insertNewObject(forEntityName: "StockEntity", into: context)
            stockEntity.setValue(stock.symbol, forKey: "symbol")
            stockEntity.setValue(stock.name, forKey: "name")
            stockEntity.setValue(stock.price, forKey: "price")
            stockEntity.setValue(stock.change, forKey: "change")
            stockEntity.setValue(stock.changePercent, forKey: "changePercent")
            stockEntity.setValue(stock.logo, forKey: "logo")
            stockEntity.setValue(stock.isFavourite ?? false, forKey: "isFavorite")
            stockEntity.setValue(stock.presentationPrice, forKey: "presentationPrice")
            stockEntity.setValue(stock.presentationPriceDynamic, forKey: "presentationPriceDynamic")
        }
        
        do {
            try context.save()
        } catch {
            print("[LocalStocksDataRepositoryImpl]: Failed to save stocks: \(error)")
        }
    }
    
    func fetchStocks(completion: @escaping ([StocksModel])->Void) {
        lock.lock()
        defer { lock.unlock() }
        
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "StockEntity")
        do {
            let stockEntities = try context.fetch(fetchRequest)
            var resultStocks: [StocksModel] = []
            for entity in stockEntities {
                if let symbol = entity.value(forKey: "symbol") as? String,
                   let name = entity.value(forKey: "name") as? String,
                   let logo = entity.value(forKey: "logo") as? String,
                   let isFavourite = entity.value(forKey: "isFavorite") as? Bool,
                   let presentationPrice = entity.value(forKey: "presentationPrice") as? String?,
                   let presentationPriceDynamic = entity.value(forKey: "presentationPriceDynamic") as? String?,
                   let price = entity.value(forKey: "price") as? Double,
                   let change = entity.value(forKey: "change") as? Double,
                   let changePercent = entity.value(forKey: "changePercent") as? Double {
                    
                    let stock = StocksModel(
                        symbol: symbol,
                        name: name,
                        price: price,
                        change: change,
                        changePercent: changePercent,
                        logo: logo,
                        isFavourite: isFavourite,
                        presentationPrice: presentationPrice,
                        presentationPriceDynamic: presentationPriceDynamic
                    )
                    resultStocks.append(stock)
                }
            }
            completion(resultStocks)
        } catch {
            completion([])
            print("[LocalStocksDataRepositoryImpl]: Failed to fetch stocks: \(error)")
        }
    }
    
    func updateFavouriteStatusOf(stock: StocksModel) {
        lock.lock()
        defer { lock.unlock() }
            
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "StockEntity")
        fetchRequest.predicate = NSPredicate(format: "symbol == %@", stock.symbol)
            
        do {
            if let stockObject = try context.fetch(fetchRequest).first {
                let currentStatus = stockObject.value(forKey: "isFavorite") as? Bool ?? false
                stockObject.setValue(!currentStatus, forKey: "isFavorite")
                try context.save()
                print("LocalStocksDataRepositoryImpl]: Stock with symbol \(stock.symbol) successfully updated.")
            } else {
                print("LocalStocksDataRepositoryImpl]: Stock with symbol \(stock.symbol) not found.")
            }
        } catch {
            print("LocalStocksDataRepositoryImpl]: Failed to update favorite status: \(error)")
        }
    }
    
    func fetchHistoryPrompts(completion: @escaping (PromptsModel?) -> Void) {
            let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "HistoryPrompts")
            do {
                if let entity = try context.fetch(fetchRequest).first,
                   let items = entity.value(forKey: "items") as? [String] {
                    completion(PromptsModel(items: items))
                } else {
                    completion(nil)
                }
            } catch {
                print("Failed to fetch HistoryPrompts: \(error)")
                completion(nil)
            }
        }

        func saveHistory(prompts: PromptsModel) {
            let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "HistoryPrompts")
            do {
                let existingEntities = try context.fetch(fetchRequest)
                for entity in existingEntities {
                    context.delete(entity)
                }
                if let entityDesc = NSEntityDescription.entity(forEntityName: "HistoryPrompts", in: context) {
                    let newEntity = NSManagedObject(entity: entityDesc, insertInto: context)
                    newEntity.setValue(prompts.items, forKey: "items")
                    try context.save()
                }
            } catch {
                print("Failed to save HistoryPrompts: \(error)")
            }
        }

        func fetchPopularPrompts(completion: @escaping (PromptsModel?) -> Void) {
            let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "PopularPrompts")
            do {
                if let entity = try context.fetch(fetchRequest).first,
                   let items = entity.value(forKey: "items") as? [String] {
                    completion(PromptsModel(items: items))
                } else {
                    completion(nil)
                }
            } catch {
                print("Failed to fetch PopularPrompts: \(error)")
                completion(nil)
            }
        }

        func savePopular(prompts: PromptsModel) {
            let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "PopularPrompts")
            do {
                let existingEntities = try context.fetch(fetchRequest)
                for entity in existingEntities {
                    context.delete(entity)
                }
                if let entityDesc = NSEntityDescription.entity(forEntityName: "PopularPrompts", in: context) {
                    let newEntity = NSManagedObject(entity: entityDesc, insertInto: context)
                    newEntity.setValue(prompts.items, forKey: "items")
                    try context.save()
                }
            } catch {
                print("Failed to save PopularPrompts: \(error)")
            }
        }
    
}

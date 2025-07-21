//
//  StocksModelContainer.swift
//  Stocks
//
//  Created by Anton Zyryanov on 21.07.2025.
//

import Foundation

extension StocksModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(StocksModel.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        symbol: String? = nil,
        name: String? = nil,
        price: Double? = nil,
        change: Double? = nil,
        changePercent: Double? = nil,
        logo: String? = nil,
        isFavourite: Bool? = nil,
        presentationPrice: String? = nil,
        presentationPriceDynamic: String? = nil
    ) -> StocksModel {
        return StocksModel(
            symbol: symbol ?? self.symbol,
            name: name ?? self.name,
            price: price ?? self.price,
            change: change ?? self.change,
            changePercent: changePercent ?? self.changePercent,
            logo: logo ?? self.logo,
            isFavourite: isFavourite ?? false,
            presentationPrice: presentationPrice ?? "",
            presentationPriceDynamic: presentationPriceDynamic ?? ""
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

typealias StocksModelsContainer = [StocksModel]

extension Array where Element == StocksModelsContainer.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(StocksModelsContainer.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

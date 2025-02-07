//
//  PlistDataService.swift
//  Product&Detail
//
//  Created by Artem Khakimullin on 06.02.2025.
//

import Foundation

protocol DataService {
    func fetchTransactions() throws -> [Transaction]
}

enum DataServiceError: Error {
    case fileNotFound(String)
    case decodingFailed(Error)
}

struct PlistDataService: DataService {
    func decodePlist<T: Decodable>(named file: String, as type: T.Type) throws -> T {
        guard let url = Bundle.main.url(
            forResource: file,
            withExtension: "plist"
        ) else {
            throw DataServiceError.fileNotFound(file)
        }
        let data = try Data(contentsOf: url)
        let decoder = PropertyListDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw DataServiceError.decodingFailed(error)
        }
    }
    
    func fetchTransactions() throws -> [Transaction] {
        return try decodePlist(named: "transactions", as: [Transaction].self)
    }
}

//
//  PlistDataService.swift
//  Product&Detail
//
//  Created by Artem Khakimullin on 06.02.2025.
//

import Foundation

protocol DataServiceProtocol {
    func loadTransaction(completion: @escaping(Result<[Transaction], PlistError>) -> Void)
    func loadRate(completion: @escaping(Result<[Rate], PlistError>) -> Void)
}

enum PlistError: Error {
    case fileNotFound(String)
    case decodingFailed(String)
}

final class PlistDataService: DataServiceProtocol {
    private let backgoundQueue = DispatchQueue(label: "backgroundQueue")
    private var transactions: [Transaction]?
    private var rates: [Rate]?
    
    func load<T: Decodable>(
        _ file: String,
        as type: T.Type,
        completion: @escaping (Result<T, PlistError>) -> Void
    ) {
            guard let fileURL = Bundle.main.url(forResource: file, withExtension: "plist") else {
                completion(.failure(.fileNotFound(file)))
                return
            }
            backgoundQueue.async {
                do {
                    let data = try Data(contentsOf: fileURL)
                    let decoder = PropertyListDecoder()
                    let decodedData = try decoder.decode(T.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(.success(decodedData))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.decodingFailed(file)))
                }
            }
        }
    }
    
    func loadTransaction(completion: @escaping(Result<[Transaction], PlistError>) -> Void) {
        if let cached = transactions {
            completion(.success(cached))
        }
        load("transactions", as: [Transaction].self) {[weak self] result in
            switch result {
            case .success(let transuctions):
                self?.transactions = transuctions
                completion(.success(transuctions))
            case . failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadRate(completion: @escaping(Result<[Rate], PlistError>) -> Void) {
        if let cached = rates {
            completion(.success(cached))
        }
        load("rates", as: [Rate].self) {[weak self] result in
            switch result {
            case .success(let rates):
                self?.rates = rates
                completion(.success(rates))
            case . failure(let error):
                completion(.failure(error))
            }
        }
    }

}

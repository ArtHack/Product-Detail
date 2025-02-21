//
//  PlistDataService.swift
//  Product&Detail
//
//  Created by Artem Khakimullin on 06.02.2025.
//

import Foundation

protocol RestServiceProtocol {
    func fetchTransaction(completion: @escaping(Result<[Transaction], DataError>) -> Void)
    func loadRate(completion: @escaping(Result<[Rate], DataError>) -> Void)
}

enum DataError: Error {
    case fileNotFound(String)
    case decodingFailed(String)
}

final class RestService: RestServiceProtocol {
    private var transactions: [Transaction]?
    private var rates: [Rate]?
    
    func load<T: Decodable>(
        _ file: String,
        as type: T.Type,
        completion: @escaping (Result<T, DataError>) -> Void
    ) {
        guard let fileURL = Bundle.main.url(forResource: file, withExtension: "plist") else {
            completion(.failure(.fileNotFound(file)))
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let data = try Data(contentsOf: fileURL)
                let decoder = PropertyListDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingFailed("Decoding Fail \(file): \(error.localizedDescription)")))
                }
            }
        }
    }
    
    func fetchTransaction(completion: @escaping(Result<[Transaction], DataError>) -> Void) {
        load("transactions", as: [Transaction].self, completion: completion)
    }
    
    func loadRate(completion: @escaping(Result<[Rate], DataError>) -> Void) {
        load("rates", as: [Rate].self, completion: completion)
    }
}

//
//  DataManagerService.swift
//  Product&Detail
//
//  Created by Artem Khakimullin on 20.02.2025.
//

import Foundation

protocol DataManagerProtocol {
    func loadDataOnce(completion: @escaping () -> Void)
    func getTransactions(completion: @escaping (Result<[Transaction], DataError>) -> Void)
    func getRates(completion: @escaping (Result<[Rate], DataError>) -> Void)
}

final class DataManager: DataManagerProtocol {
    static let shared = DataManager()
    
    private let restService: RestServiceProtocol
    private let databaseService: DatabaseServiceProtocol
    
    private init(
        restService: RestService = RestService(),
        databaseService: DatabaseService = DatabaseService.shared
    ) {
        self.restService = restService
        self.databaseService = databaseService
    }
    
    func loadDataOnce(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        restService.fetchTransaction { [weak self] result in
            if case .success(let transactions) = result {
                self?.databaseService.saveTransactions(transactions)
            }
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        restService.loadRate { [weak self] result in
            if case .success(let rates) = result {
                self?.databaseService.saveRates(rates)
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func getTransactions(completion: @escaping (Result<[Transaction], DataError>) -> Void) {
        if let transactions = databaseService.getTransactions() {
            completion(.success(transactions))
        } else {
            completion(.failure(.fileNotFound("transactions")))
        }
    }
    
    func getRates(completion: @escaping (Result<[Rate], DataError>) -> Void) {
        if let rates = databaseService.getRates() {
            completion(.success(rates))
        } else {
            completion(.failure(.fileNotFound("rates")))
        }
    }
}

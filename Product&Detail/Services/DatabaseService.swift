//
//  DatabaseService.swift
//  Product&Detail
//
//  Created by Artem Khakimullin on 20.02.2025.
//

import Foundation

protocol DatabaseServiceProtocol {
    func getTransactions() -> [Transaction]?
    func getRates() -> [Rate]?
    func saveTransactions(_ transaction: [Transaction])
    func saveRates(_ rates: [Rate])
}

final class DatabaseService: DatabaseServiceProtocol {
    static let shared = DatabaseService()
    
    private var transactions: [Transaction]?
    private var rates: [Rate]?
    
    private init() {}
    
    func getTransactions() -> [Transaction]? {
        return transactions
    }
    
    func getRates() -> [Rate]? {
        return rates
    }
    
    func saveTransactions(_ transaction: [Transaction]) {
        self.transactions = transaction
    }
    
    func saveRates(_ rates: [Rate]) {
        self.rates = rates
    }
}

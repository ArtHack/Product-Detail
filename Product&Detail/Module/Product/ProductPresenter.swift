//
//  ProductPresenter.swift
//  Product&Detail
//
//  Created by Artem Khakimullin on 07.02.2025.
//

import Foundation

final class ProductPresenter {
    private let dataService: DataServiceProtocol
    private(set) var products: [ProductModel] = []
    
    init(dataService: DataServiceProtocol = PlistDataService()) {
        self.dataService = dataService
    }
    

    func loadProducts(completion: @escaping () -> Void) {
        dataService.loadTransaction { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let transactions):
                let models = transactions.map { transaction -> ProductModel in
                    let intAmount = Double(transaction.amount) ?? 0
                    return ProductModel(
                        amount: intAmount,
                        currency: transaction.currency,
                        sku: transaction.sku
                    )
                }
                self.products = models
            case .failure(let error):
                print("Error loading transactions: \(error)")
            }
            completion()
        }
    }
}


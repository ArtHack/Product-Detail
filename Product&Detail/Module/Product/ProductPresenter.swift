//
//  ProductPresenter.swift
//  Product&Detail
//
//  Created by Artem Khakimullin on 07.02.2025.
//

import Foundation

final class ProductPresenter {
    private let dataService: DataServiceProtocol
    private(set) var products: [Product]?
    private(set) var sortedBySku: [ProductViewModel]?
    
    init(dataService: DataServiceProtocol = PlistDataService()) {
        self.dataService = dataService
    }
    
    func loadProducts(completion: @escaping () -> Void) {
        dataService.loadTransaction { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let transactions):
                let models = transactions.map { transaction -> Product in
                    let intAmount = Double(transaction.amount) ?? 0
                    return Product(
                        amount: intAmount,
                        currency: transaction.currency,
                        sku: transaction.sku
                    )
                }
                self.products = models
                guard let products = self.products else { return }
                self.sortedBySku = sortBySku(from: products)
                
            case .failure(let error):
                print("Error loading transactions: \(error)")
            }
            completion()
        }
    }
    
    func sortBySku(from products: [Product]) -> [ProductViewModel] {
        let groupProduct = Dictionary(grouping: products, by: \.sku)
        let viewModel = groupProduct.map { (sku, totalProduct) -> ProductViewModel in
            let total = totalProduct.count
            return ProductViewModel(sku: sku, count: String(total))
        }
        let sortedViewModel = viewModel.sorted { $0.sku < $1.sku }
        return sortedViewModel
    }
}


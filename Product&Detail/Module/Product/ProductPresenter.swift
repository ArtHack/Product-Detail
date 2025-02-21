//
//  ProductPresenter.swift
//  Product&Detail
//
//  Created by Artem Khakimullin on 07.02.2025.
//

import Foundation

protocol ProductPresenterProtocol {
    func viewDidLoad()
    func showDetail()
}

final class ProductPresenter: ProductPresenterProtocol {

    weak var view: ProductViewProtocol?

    private let dataManager: DataManagerProtocol
    private let router: ProductRouterProtocol
    
    private(set) var products: [Product]?
    private(set) var sortedBySku: [ProductView.ProductViewModel]?
        
    init(dataManager: DataManagerProtocol, router: ProductRouterProtocol) {
        self.dataManager = dataManager
        self.router = router
    }

    func viewDidLoad() {
        dataManager.getTransactions { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let transactions):
                let models = transactions.map { transaction -> Product in
                    let doubleAmount = Double(transaction.amount) ?? 0
                    return Product(
                        amount: doubleAmount,
                        currency: transaction.currency,
                        sku: transaction.sku
                    )
                }
                self.products = models
                guard let products = self.products else { return }

                let data = self.sortBySku(from: products)
                DispatchQueue.main.async {
                    self.view?.update(model: data)
                }
            case .failure(let error):
                print("❌ Ошибка загрузки транзакций:", error)
            }
        }
    }
    
    func sortBySku(from products: [Product]) -> [ProductView.ProductViewModel] {
        let groupProduct = Dictionary(grouping: products, by: \.sku)
        let viewModel = groupProduct.map { (sku, totalProduct) -> ProductView.ProductViewModel in
            let total = totalProduct.count
            return ProductView.ProductViewModel(sku: sku, count: String(total))
        }
        let sortedViewModel = viewModel.sorted { $0.sku < $1.sku }
        return sortedViewModel
    }
    
    func showDetail() {
        router.showDetail()
    }
}


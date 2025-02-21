//
//  ProductView.swift
//  Product&Detail
//
//  Created by Artem Khakimullin on 11.02.2025.
//

import UIKit

final class ProductView: UIView {
    
    /// Model for UI Layer
    struct ProductViewModel {
        let sku: String
        let count: String
    }
    
    private let presenter: ProductPresenterProtocol
    
    init(presenter: ProductPresenterProtocol) {
        self.presenter = presenter
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

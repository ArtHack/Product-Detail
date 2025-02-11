//
//  Product.swift
//  Product&Detail
//
//  Created by Artem Khakimullin on 07.02.2025.
//

import Foundation

/// Model for Domain Layer
struct Product {
    let amount: Double
    let currency: String
    let sku: String
}

/// Model for UI Layer
struct ProductViewModel {
    let sku: String
    let count: String
}

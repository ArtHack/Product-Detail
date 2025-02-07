//
//  Transaction.swift
//  Product&Detail
//
//  Created by Artem Khakimullin on 06.02.2025.
//

import Foundation

struct Transaction: Decodable {
    let amount: String
    let currency: String
    let sku: String
}

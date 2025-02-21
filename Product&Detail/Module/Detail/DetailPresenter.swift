//
//  DetailPresenter.swift
//  Product&Detail
//
//  Created by Artem Khakimullin on 18.02.2025.
//

import Foundation

final class DetailPresenter {
    
    struct TotalModel {
        let total: Double
    }
    
    struct DetailModel {
        let transactionCurrency: Double
        let baseCurrency: Double
    }
    
    let service: RestServiceProtocol
    
    init(service: RestServiceProtocol) {
        self.service = service
    }
    

}

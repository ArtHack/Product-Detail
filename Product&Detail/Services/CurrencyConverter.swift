//
//  CurrencyConverter.swift
//  Product&Detail
//
//  Created by Artem Khakimullin on 20.02.2025.
//

import Foundation

class CurrencyConverter {
    private var exchageRates: [Rate] = []
    
    init(rates: [Rate]) {
        self.exchageRates = rates
    }
    
    func getRate(from baseCurrency: String, to targetCurrency: String) -> Double? {
        return exchageRates.first {
            $0.from.uppercased() == baseCurrency.uppercased() &&
            $0.to.uppercased() == targetCurrency.uppercased()
        }?.rate
    }
    
    func crossRate(from baseCurrency: String, to targetCurrency: String) -> Double? {
        guard let baseToUSD = getRate(from: baseCurrency, to: "USD"),
              let usdToTarget = getRate(from: "USD", to: targetCurrency) else {
            return nil
        }
        
        return usdToTarget / baseToUSD
    }
}

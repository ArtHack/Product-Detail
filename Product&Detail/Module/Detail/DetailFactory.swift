//
//  DetailFactory.swift
//  Product&Detail
//
//  Created by Artem Khakimullin on 11.02.2025.
//

import UIKit

final class DetailFactory {
    struct Context {
        let someContext: String
    }
    
    func make(context: Context) -> UIViewController {
        return UIViewController()
    }
}

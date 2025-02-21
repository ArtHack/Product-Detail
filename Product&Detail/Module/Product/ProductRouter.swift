//
//  ProductRouter.swift
//  Product&Detail
//
//  Created by Artem Khakimullin on 11.02.2025.
//

import UIKit

protocol ProductRouterProtocol: AnyObject {
    func showDetail()
}

final class ProductRouter: ProductRouterProtocol {
    private let factory: DetailFactory
    private weak var root: UIViewController?
    
    init(factory: DetailFactory) {
        self.factory = factory
    }
    
    func setRootViewController(root: UIViewController) {
        self.root = root
    }
    
    func showDetail() {
        root?.navigationController?.pushViewController(DetailViewController(), animated: true)
    }
}

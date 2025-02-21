//
//  ProductFactory.swift
//  Product&Detail
//
//  Created by Artem Khakimullin on 11.02.2025.
//

import UIKit

final class ProductFactory {
    
    struct Context {
        
    }
    
    func make() -> UIViewController {
        
        let router = ProductRouter(factory: DetailFactory())
                
        let presenter = ProductPresenter(
            dataManager: DataManager.shared,
            router: router
        )
        let vc = ProductViewController(presenter: presenter)

        presenter.view = vc
        router.setRootViewController(root: vc)
        
        return vc
    }
}

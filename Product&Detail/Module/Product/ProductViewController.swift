//
//  ViewController.swift
//  Product&Detail
//
//  Created by Artem Khakimullin on 06.02.2025.
//

import UIKit

protocol ProductViewProtocol: AnyObject {
    func update(model: [ProductView.ProductViewModel])
}

class ProductViewController: UIViewController {
    
    private let presenter: ProductPresenterProtocol
    private lazy var productView = ProductView(presenter: presenter)
    
    var data: [ProductView.ProductViewModel] = []
    
    let tableView = UITableView()
    
    init(presenter: ProductPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = productView
        presenter.viewDidLoad()
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension ProductViewController: ProductViewProtocol {
    func update(model: [ProductView.ProductViewModel]) {
        self.data = model
        print("📲 ViewController: Данные переданы в update(model:):", model) // ✅ Проверка
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension ProductViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                    return UITableViewCell()
                }
                var content = cell.defaultContentConfiguration()
                let transactionSummary = data[indexPath.row]
                content.text = transactionSummary.sku
                content.prefersSideBySideTextAndSecondaryText = true
                content.secondaryText = "\(transactionSummary.count) transactions"
                content.secondaryTextProperties.font = .systemFont(ofSize: 16, weight: .light)
                cell.accessoryType = .disclosureIndicator
                cell.contentConfiguration = content
                return cell
    }
}

// MARK: - UITableViewDelegate
extension ProductViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        presenter.showDetail()
    }
}

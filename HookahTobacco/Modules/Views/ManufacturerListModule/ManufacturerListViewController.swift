//
//
//  ManufacturerListViewController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 13.10.2022.
//
//

import UIKit

protocol ManufacturerListViewInputProtocol: AnyObject {
    func showError(with message: String)
    func showData()
    func showRow(_ row: Int)
}

protocol ManufacturerListViewOutputProtocol: AnyObject {
    var numberOfRows: Int { get }
    func getViewModel(by row: Int) -> ManufacturerListEntity.ViewModel
    func viewDidLoad()
    func didTouchForElement(by row: Int)
}

class ManufacturerListViewController: UIViewController {
    var presenter: ManufacturerListViewOutputProtocol!
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ManufacturerListTableViewCell.self,
                           forCellReuseIdentifier: ManufacturerListTableViewCell.identifier)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Производители табаков"
        setupSubviews()
        presenter.viewDidLoad()
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ManufacturerListViewController: ManufacturerListViewInputProtocol {
    func showError(with message: String) {
        showAlertError(title: "Ошибка", message: message)
    }
    
    func showData() {
        tableView.reloadData()
    }
    
    func showRow(_ row: Int) {
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
}

extension ManufacturerListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ManufacturerListTableViewCell.identifier, for: indexPath) as! ManufacturerListTableViewCell
        let viewModel = presenter.getViewModel(by: indexPath.row)
        cell.setCell(name: viewModel.name, country: viewModel.country, image: viewModel.image)
        return cell
    }
}

extension ManufacturerListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTouchForElement(by: indexPath.row)
    }
}

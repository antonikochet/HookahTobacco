//
//
//  TobaccoListViewController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 26.10.2022.
//
//

import UIKit
import SnapKit

protocol TobaccoListViewInputProtocol: AnyObject {
    func showData()
    func updateRow(at index: Int)
    func showErrorAlert(with message: String)
}

protocol TobaccoListViewOutputProtocol: AnyObject {
    var numberOfRows: Int { get }
    func cellViewModel(at index: Int) -> TobaccoListCellViewModel
    func viewDidLoad()
    func didTouchForElement(by index: Int)
}

class TobaccoListViewController: UIViewController {
    var presenter: TobaccoListViewOutputProtocol!
    
    //MARK: subviews
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TobaccoListCell.self, forCellReuseIdentifier: TobaccoListCell.identifier)
        return tableView
    }()
    
    //MARK: override viewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }
    
    //MARK: setups
    private func setup() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK: private methods
    
}

extension TobaccoListViewController: TobaccoListViewInputProtocol {
    func showData() {
        tableView.reloadData()
    }
    
    func updateRow(at index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
    
    func showErrorAlert(with message: String) {
        showAlertError(title: "Ошибка", message: message)
    }
}

extension TobaccoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TobaccoListCell.identifier, for: indexPath) as! TobaccoListCell
        let viewModel = presenter.cellViewModel(at: indexPath.row)
        cell.viewModel = viewModel
        return cell
    }
}

extension TobaccoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTouchForElement(by: indexPath.row)
    }
}

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
    func didStartingRefreshView()
}

class TobaccoListViewController: UIViewController {
    // MARK: - Public properties
    var presenter: TobaccoListViewOutputProtocol!
    
    // MARK: - Private properties
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TobaccoListCell.self, forCellReuseIdentifier: TobaccoListCell.identifier)
        return tableView
    }()
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Live Cycle ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }
    
    // MARK: - Setups
    private func setup() {
        navigationItem.title = "Табаки"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
    }
    
    // MARK: - Private methods
    
    // MARK: - Selectors
    @objc private func refreshTableView() {
        presenter.didStartingRefreshView()
    }
}

// MARK: - ViewInputProtocol implementation
extension TobaccoListViewController: TobaccoListViewInputProtocol {
    func showData() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func updateRow(at index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
    
    func showErrorAlert(with message: String) {
        showAlertError(title: "Ошибка", message: message)
    }
}

// MARK: - UITableViewDataSource implementation
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

// MARK: - UITableViewDelegate implementation
extension TobaccoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTouchForElement(by: indexPath.row)
    }
}

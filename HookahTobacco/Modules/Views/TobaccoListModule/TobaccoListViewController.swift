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

protocol TobaccoListViewInputProtocol: ViewProtocol {
    func getTableView() -> UITableView
    func endRefreshing()
}

protocol TobaccoListViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func didStartingRefreshView()
}

class TobaccoListViewController: BaseViewController {
    // MARK: - Public properties
    var presenter: TobaccoListViewOutputProtocol!

    // MARK: - Private properties
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }

    // MARK: - Setups
    private func setup() {
        setupScreen()
        setupTableView()
    }

    private func setupScreen() {
        navigationItem.title = .title
        view.backgroundColor = .clear
    }
    private func setupTableView() {
        tableView.refreshControl = refreshControl

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

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
    func getTableView() -> UITableView {
        tableView
    }

    func endRefreshing() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
}

private extension String {
    static let title = "Табаки"
}

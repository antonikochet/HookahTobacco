//
//
//  ManufacturerListViewController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 13.10.2022.
//
//

import UIKit
import SnapKit

protocol ManufacturerListViewInputProtocol: ViewProtocol {
    func getTableView() -> UITableView
    func endRefreshing()
}

protocol ManufacturerListViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func viewDidAppear()
    func didStartingRefreshView()
}

class ManufacturerListViewController: BaseViewController {
    // MARK: - Public properties
    var presenter: ManufacturerListViewOutputProtocol!

    // MARK: - UI properties
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
    // MARK: - Setups
    private func setup() {
        setupScreen()
        setupTableView()
    }

    private func setupScreen() {
        navigationItem.title = .title
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
extension ManufacturerListViewController: ManufacturerListViewInputProtocol {
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
    static let title = "Производители табаков"
}

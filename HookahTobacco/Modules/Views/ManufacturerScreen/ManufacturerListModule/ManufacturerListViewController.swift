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

    // MARK: - Setups
    private func setup() {
        setupScreen()
        setupTableView()
    }

    private func setupScreen() {
        navigationItem.title = R.string.localizable.manufacteurerListTitle()
    }
    private func setupTableView() {
        tableView.refreshControl = refreshControl
        tableView.separatorStyle = .none
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }

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

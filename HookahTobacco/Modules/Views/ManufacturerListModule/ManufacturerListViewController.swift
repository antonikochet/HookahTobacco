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

protocol ManufacturerListViewInputProtocol: AnyObject {
    func getTableView() -> UITableView
    func endRefreshing()
    func showProgressView()
    func hideProgressView()
}

protocol ManufacturerListViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func didStartingRefreshView()
}

class ManufacturerListViewController: UIViewController {
    // MARK: - Public properties
    var presenter: ManufacturerListViewOutputProtocol!

    // MARK: - UI properties
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

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
        setupActivityIndicator()
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
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = true

        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
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

    func showProgressView() {
        activityIndicator.startAnimating()
    }

    func hideProgressView() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}

private extension String {
    static let title = "Производители табаков"
}

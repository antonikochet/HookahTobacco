//
//
//  AppealsListViewController.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 19.09.2023.
//
//

import UIKit

protocol AppealsListViewInputProtocol: ViewProtocol {
    func getTableView() -> UITableView
}

protocol AppealsListViewOutputProtocol: AnyObject {
    func viewDidLoad()
}

class AppealsListViewController: BaseViewController {
    // MARK: - Public properties
    var presenter: AppealsListViewOutputProtocol!

    // MARK: - UI properties
    private let tableView = UITableView()

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter.viewDidLoad()
    }

    // MARK: - Setups
    private func setupUI() {
        setupScreen()
        setupTableView()
    }
    private func setupScreen() {
        view.backgroundColor = R.color.primaryBackground()
        navigationItem.title = R.string.localizable.appealsListTitle()
    }
    private func setupTableView() {
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    // MARK: - Private methods

    // MARK: - Selectors

}

// MARK: - ViewInputProtocol implementation
extension AppealsListViewController: AppealsListViewInputProtocol {
    func getTableView() -> UITableView {
        tableView
    }
}

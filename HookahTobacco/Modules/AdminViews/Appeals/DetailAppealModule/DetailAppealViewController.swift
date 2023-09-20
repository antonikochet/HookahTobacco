//
//
//  DetailAppealViewController.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 20.09.2023.
//
//

import UIKit

protocol DetailAppealViewInputProtocol: ViewProtocol {
    func getTableView() -> UITableView
}

protocol DetailAppealViewOutputProtocol: AnyObject {
    func viewDidLoad()
}

class DetailAppealViewController: BaseViewController {
    // MARK: - Public properties
    var presenter: DetailAppealViewOutputProtocol!

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
    }
    private func setupTableView() {
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    // MARK: - Private methods

    // MARK: - Selectors

}

// MARK: - ViewInputProtocol implementation
extension DetailAppealViewController: DetailAppealViewInputProtocol {
    func getTableView() -> UITableView {
        tableView
    }
}

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
    func showData()
    func showRow(_ row: Int)
}

protocol ManufacturerListViewOutputProtocol: AnyObject {
    var numberOfRows: Int { get }
    func getViewModel(by row: Int) -> ManufacturerListEntity.ViewModel
    func viewDidLoad()
    func didTouchForElement(by row: Int)
    func didStartingRefreshView()
}

class ManufacturerListViewController: UIViewController {
    // MARK: - Public properties
    var presenter: ManufacturerListViewOutputProtocol!

    // MARK: - Private properties
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ManufacturerListTableViewCell.self,
                           forCellReuseIdentifier: ManufacturerListTableViewCell.identifier)

        return tableView
    }()

    private let refreshControl = UIRefreshControl()

    // MARK: - Live Cycle ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Производители табаков"
        setupSubviews()
        presenter.viewDidLoad()
    }

    // MARK: - Setups
    private func setupSubviews() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
extension ManufacturerListViewController: ManufacturerListViewInputProtocol {
    func showData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }

    func showRow(_ row: Int) {
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
        }
    }
}

// MARK: - UITableViewDataSource implementation
extension ManufacturerListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows
    }

    // swiftlint: disable force_cast
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ManufacturerListTableViewCell.identifier,
                                                 for: indexPath) as! ManufacturerListTableViewCell
        let viewModel = presenter.getViewModel(by: indexPath.row)
        cell.setCell(name: viewModel.name, country: viewModel.country, image: viewModel.image)
        return cell
    }
    // swiftlint: enable force_cast
}

// MARK: - UITableViewDelegate implementation
extension ManufacturerListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 8
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTouchForElement(by: indexPath.row)
    }
}

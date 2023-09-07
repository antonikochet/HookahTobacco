//
//
//  DetailInfoManufacturerViewController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 31.10.2022.
//
//

import UIKit
import SnapKit

protocol DetailInfoManufacturerViewInputProtocol: AnyObject {
    func getTableView() -> UITableView
    func setupNameManufacturer(_ nameManufacturer: String)
}

protocol DetailInfoManufacturerViewOutputProtocol: AnyObject {
    func viewDidLoad()
}

class DetailInfoManufacturerViewController: UIViewController {
    // MARK: - Public properties
    var presenter: DetailInfoManufacturerViewOutputProtocol!

    // MARK: - UI properties
    private var tableView = UITableView()

    // MARK: - Life Cycle ViewController
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

    }
    private func setupTableView() {
        tableView.separatorStyle = .none
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
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
extension DetailInfoManufacturerViewController: DetailInfoManufacturerViewInputProtocol {
    func getTableView() -> UITableView {
        tableView
    }

    func setupNameManufacturer(_ nameManufacturer: String) {
        navigationItem.title = nameManufacturer
    }
}

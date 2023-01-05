//
//
//  ProfileViewController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 04.01.2023.
//
//

import UIKit
import SnapKit

protocol ProfileViewInputProtocol: AnyObject {
    func getTableView() -> UITableView
    func showSpinner()
    func hideSpinner()
}

protocol ProfileViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func pressedLogoutButton()
}

final class ProfileViewController: UIViewController {
    // MARK: - Public properties
    var presenter: ProfileViewOutputProtocol!

    // MARK: - UI properties
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView()

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
        setupActivityIndicator()
    }

    private func setupScreen() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "log out",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(touchRightButtonNavBar))
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
    }

    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
    }

    // MARK: - Private methods

    // MARK: - Selectors
    @objc private func touchRightButtonNavBar() {
        presenter.pressedLogoutButton()
    }
}

// MARK: - ViewInputProtocol implementation
extension ProfileViewController: ProfileViewInputProtocol {
    func getTableView() -> UITableView {
        tableView
    }

    func showSpinner() {
        activityIndicator.startAnimating()
    }

    func hideSpinner() {
        activityIndicator.stopAnimating()
    }
}

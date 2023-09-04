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

protocol ProfileViewInputProtocol: ViewProtocol {
    func getTableView() -> UITableView
}

protocol ProfileViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func pressedLogoutButton()
}

final class ProfileViewController: BaseViewController {
    // MARK: - Public properties
    var presenter: ProfileViewOutputProtocol!

    // MARK: - UI properties
    private let tableView = UITableView()

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        presenter.viewWillAppear()
    }

    // MARK: - Setups
    private func setupUI() {
        setupScreen()
        setupTableView()
    }

    private func setupScreen() {
        let button = UIButton()
        button.setTitle(R.string.localizable.profileLogout(), for: .normal)
        button.setTitleColor(R.color.primarySubtitle(), for: .normal)
        button.addTarget(self, action: #selector(touchRightButtonNavBar), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
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
}

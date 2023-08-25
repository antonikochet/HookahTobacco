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
    func setupView(title: String, isShowSearch: Bool)
    func hideKeyboard()
    func getSearchView() -> UISearchBar
    func showKeyboard()
}

protocol TobaccoListViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func didStartingRefreshView()
    func updateSearchText(_ text: String?)
}

class TobaccoListViewController: BaseViewController {
    // MARK: - Public properties
    var presenter: TobaccoListViewOutputProtocol!

    // MARK: - Private properties
    private let searchBar = UISearchBar()
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
        setupSearchBar()
        setupTableView()
    }

    private func setupScreen() {
        view.backgroundColor = .systemBackground
    }
    private func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.placeholder = "Поиск"
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
    private func setupTableView() {
        tableView.refreshControl = refreshControl

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
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

    func setupView(title: String, isShowSearch: Bool) {
        self.title = title
        tableView.snp.makeConstraints { make in
            if isShowSearch {
                make.top.equalTo(searchBar.snp.bottom)
            } else {
                make.top.equalToSuperview()
            }
        }
    }

    func hideKeyboard() {
        self.view.endEditing(true)
    }

    func getSearchView() -> UISearchBar {
        searchBar
    }

    func showKeyboard() {
        searchBar.becomeFirstResponder()
    }
}

// MARK: - UISearchBarDelegate implementation
extension TobaccoListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        view.endEditing(true)
        presenter.updateSearchText(nil)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        view.endEditing(true)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.updateSearchText(searchText)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        view.endEditing(true)
    }
}

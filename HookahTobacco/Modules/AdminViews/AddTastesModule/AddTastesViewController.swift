//
//
//  AddTastesViewController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 12.11.2022.
//
//

import UIKit
import SnapKit

protocol AddTastesViewInputProtocol: AnyObject {
    func getTableView() -> UITableView
    func getSelectCollectionView() -> CustomCollectionView
}

protocol AddTastesViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func didTouchAdd()
    func selectedTastesDone()
    func didStartSearch(with text: String)
    func didEndSearch()
}

class AddTastesViewController: UIViewController {
    // MARK: - Public properties
    var presenter: AddTastesViewOutputProtocol!

    // MARK: - UI properties
    private let searchBar = UISearchBar()
    private let tasteCollectionView = CustomCollectionView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let addButton = IconButton()

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Добавление вкусов"
        view.backgroundColor = .systemBackground

        setupNavigationItem()
        setupSubviews()
        presenter.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        addButton.createCornerRadius()
    }
    // MARK: - Setups    
    private func setupSubviews() {
        view.addSubview(tasteCollectionView)
        tasteCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(spacingBetweenViews)
        }

        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.placeholder = "Фильтр вкусов"
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(tasteCollectionView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(24)
            make.trailing.equalToSuperview().inset(24)
        }
        addButton.action = { [weak self] in
            self?.presenter.didTouchAdd()
        }
        addButton.buttonSize = 50.0
        addButton.imageSize = 25.0
        addButton.image = UIImage(systemName: "plus")
        addButton.backgroundColor = .systemOrange
        addButton.imageColor = .white
        addButton.createCornerRadius()
    }

    private func setupNavigationItem() {
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTouchDoneButton)
        )
        navigationItem.rightBarButtonItem = doneButton
    }

    // MARK: - Private methods

    // MARK: - Selectors
    @objc private func didTouchDoneButton() {
        presenter.selectedTastesDone()
    }
}

// MARK: - ViewInputProtocol implementation
extension AddTastesViewController: AddTastesViewInputProtocol {
    func getTableView() -> UITableView {
        tableView
    }

    func getSelectCollectionView() -> CustomCollectionView {
        tasteCollectionView
    }
}

// MARK: - UISearchResultsUpdating implementation
extension AddTastesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        presenter.didStartSearch(with: text)
    }
}

// MARK: - UISearchBarDelegate implementation
extension AddTastesViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        view.endEditing(true)
        presenter.didEndSearch()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        view.endEditing(true)
        presenter.didStartSearch(with: text)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.didStartSearch(with: searchText)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        view.endEditing(true)
    }
}

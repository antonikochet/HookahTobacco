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
    func setupContent()
    func showError(with message: String)
    func updateRowAndSelect(by index: Int)
}

protocol AddTastesViewOutputProtocol: AnyObject {
    func viewDidLoad()
    var selectedNumberOfRows: Int { get }
    func getSelectedViewModel(by index: Int) -> TasteCollectionCellViewModel
    var tastesNumberOfRows: Int { get }
    func getViewModel(by index: Int) -> AddTastesTableCellViewModel
    func didSelectTaste(by index: Int)
    func didTouchAdd()
    func selectedTastesDone()
    func didEditingTaste(by index: Int)
    func didStartSearch(with text: String)
    func didEndSearch()
}

class AddTastesViewController: UIViewController {
    // MARK: - Public properties
    var presenter: AddTastesViewOutputProtocol!

    // MARK: - UI properties
    private let searchBar = UISearchBar()
    private let tasteCollectionView = TasteCollectionView()

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(AddTastesTableViewCell.self,
                           forCellReuseIdentifier: AddTastesTableViewCell.identifier)
        return tableView
    }()

    private let addButton = UIButton.createAppBigButton(image: UIImage(systemName: "plus")?
                                                                .withRenderingMode(.alwaysTemplate),
                                                        fontSise: 25)

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
        tasteCollectionView.tasteDelegate = self

        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.placeholder = "Фильтр вкусов"
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(tasteCollectionView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(24)
            make.trailing.equalToSuperview().inset(24)
        }
        addButton.addTarget(self, action: #selector(didTouchAddButton), for: .touchUpInside)
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
    @objc
    private func didTouchAddButton() {
        presenter.didTouchAdd()
    }

    @objc
    private func didTouchDoneButton() {
        presenter.selectedTastesDone()
    }
}

// MARK: - ViewInputProtocol implementation
extension AddTastesViewController: AddTastesViewInputProtocol {
    func setupContent() {
        tableView.reloadData()
        tasteCollectionView.reloadData()
    }

    func showError(with message: String) {
        showAlertError(title: "Ошибка", message: message)
    }

    func updateRowAndSelect(by index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        if tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        tasteCollectionView.reloadData()
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

// MARK: - UITableViewDataSource implementation
extension AddTastesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.tastesNumberOfRows
    }

    // swiftlint: disable force_cast
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddTastesTableViewCell.identifier,
                                                 for: indexPath) as! AddTastesTableViewCell
        cell.viewModel = presenter.getViewModel(by: indexPath.row)
        return cell
    }
    // swiftlint: enable force_cast

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - UITableViewDelegate implementation
extension AddTastesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectTaste(by: indexPath.row)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Изменить") { [weak self] (_, _, completionHandler) in
            self?.presenter.didEditingTaste(by: indexPath.row)
            completionHandler(true)
        }
        edit.backgroundColor = .systemOrange
        let configuration = UISwipeActionsConfiguration(actions: [edit])
        return configuration
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - UICollectionViewDelegate implementation
extension AddTastesViewController: TasteCollectionViewDelegate {
    func getItem(at index: Int) -> TasteCollectionCellViewModel {
        presenter.getSelectedViewModel(by: index)
    }

    var numberOfRows: Int {
        presenter.selectedNumberOfRows
    }

    func didSelectTaste(at index: Int) {

    }
}

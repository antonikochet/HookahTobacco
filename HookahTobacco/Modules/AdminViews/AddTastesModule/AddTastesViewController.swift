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
    func getTasteCollectionView() -> UICollectionView
    func updateRowAndSelect(by index: Int)
}

protocol AddTastesViewOutputProtocol: AnyObject {
    func viewDidLoad()
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
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var addButton: UIButton!

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        presenter.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        addButton.createCornerRadius()
    }
    // MARK: - Setups    
    private func setup() {
        setupScreenView()
        setupNavigationItem()
        setupTasteCollectionView()
        setupSearchBar()
        setupTableView()
        setupAddButton()
    }
    private func setupScreenView() {
        navigationItem.title = .title
        view.backgroundColor = Colors.Screen.background
    }
    private func setupNavigationItem() {
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTouchDoneButton)
        )
        navigationItem.rightBarButtonItem = doneButton
    }
    private func setupTasteCollectionView() {
        view.addSubview(tasteCollectionView)
        tasteCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.TasteCollectionView.horizPadding)
        }
    }
    private func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.placeholder = .searchBarPlaceholder
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(tasteCollectionView.snp.bottom).offset(LayoutValues.SearchBar.top)
            make.leading.trailing.equalToSuperview()
        }
    }
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)//.offset(LayoutValues.TableView.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    private func setupAddButton() {
        addButton = UIButton.createAppBigButton(image: Images.add, fontSise: 25)
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.size.equalTo(LayoutValues.AddButton.size)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(LayoutValues.AddButton.bottom)
            make.trailing.equalToSuperview().inset(LayoutValues.AddButton.trailing)
        }
        addButton.addTarget(self, action: #selector(didTouchAddButton), for: .touchUpInside)
    }

    // MARK: - Private methods

    // MARK: - Selectors
    @objc private func didTouchAddButton() {
        presenter.didTouchAdd()
    }

    @objc private func didTouchDoneButton() {
        presenter.selectedTastesDone()
    }
}

// MARK: - ViewInputProtocol implementation
extension AddTastesViewController: AddTastesViewInputProtocol {
    func getTableView() -> UITableView {
        tableView
    }

    func getTasteCollectionView() -> UICollectionView {
        tasteCollectionView
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

// MARK: - UITableViewDelegate implementation
extension AddTastesViewController: UITableViewDelegate {
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
}

private extension String {
    static let title = "Добавление вкусов"
    static let searchBarPlaceholder = "Фильтр вкусов"
}
private struct LayoutValues {
    struct TasteCollectionView {
        static let horizPadding: CGFloat = 16.0
    }
    struct SearchBar {
        static let top: CGFloat = 8.0
    }
    struct TableView {
        static let top: CGFloat = 16.0
    }
    struct AddButton {
        static let size: CGFloat = 50.0
        static let bottom: CGFloat = 24.0
        static let trailing: CGFloat = 24.0
    }
}
private struct Images {
    static let add = UIImage(systemName: "plus")!.withRenderingMode(.alwaysTemplate)
}
private struct Colors {
    struct Screen {
        static let background = UIColor.systemBackground
    }
}
private struct Fonts { }

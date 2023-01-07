//
//
//  TobaccoListPresenter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 26.10.2022.
//
//

import Foundation
import TableKit

class TobaccoListPresenter {
    // MARK: - Public properties
    weak var view: TobaccoListViewInputProtocol!
    var interactor: TobaccoListInteractorInputProtocol!
    var router: TobaccoListRouterProtocol!

    // MARK: - Private properties
//    private var viewModels: [TobaccoListCellViewModel] = []
    private var tableDirector: TableDirector!

    // MARK: - Private methods
    private func createItem(for tobacco: TobaccoListEntity.Tobacco) -> TobaccoListTableCellItem {
        let taste = tobacco.tasty
            .map { $0.taste }
            .joined(separator: ", ")
        return TobaccoListTableCellItem(
            name: tobacco.name,
            tasty: taste,
            manufacturerName: tobacco.nameManufacturer,
            image: tobacco.image
        )
    }
    private func createRow(at item: TobaccoListTableCellItem) -> Row {
        TableRow<TobaccoListCell>(item: item).on(.click) { [weak self] options in
            self?.interactor.receiveDataForShowDetail(by: options.indexPath.row)
        }
    }

    private func setupContentView(_ tobaccos: [TobaccoListEntity.Tobacco]) {
        tableDirector.clear()
        var rows: [Row] = []

        for tobacco in tobaccos {
            let item = createItem(for: tobacco)
            let row = createRow(at: item)
            rows.append(row)
        }

        let section = TableSection(rows: rows)
        section.headerHeight = 0.0
        section.footerHeight = 0.0
        tableDirector += section
        reloadData()
    }

    private func updateContentView(_ tobacco: TobaccoListEntity.Tobacco, at index: Int) {
        let item = createItem(for: tobacco)
        let indexPath = IndexPath(row: index, section: 0)
        let row = createRow(at: item)
        DispatchQueue.main.async { [weak self] in
            self?.tableDirector.reloadRow(at: indexPath, with: row)
        }
    }

    private func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableDirector.reload()
        }
    }
}

// MARK: - InteractorOutputProtocol implementation
extension TobaccoListPresenter: TobaccoListInteractorOutputProtocol {
    func receivedSuccess(_ data: [TobaccoListEntity.Tobacco]) {
        setupContentView(data)
        view.endRefreshing()
    }

    func receivedError(with message: String) {
        router.showError(with: message)
    }

    func receivedUpdate(for data: TobaccoListEntity.Tobacco, at index: Int) {
        updateContentView(data, at: index)
    }

    func receivedDataForShowDetail(_ tobacco: Tobacco) {
        router.showDetail(for: tobacco)
    }

    func receivedDataForEditing(_ tobacco: Tobacco) {
        router.showAddTobacco(tobacco, delegate: self)
    }
}

// MARK: - ViewOutputProtocol implementation
extension TobaccoListPresenter: TobaccoListViewOutputProtocol {
    func viewDidLoad() {
        let tableView = view.getTableView()
        tableDirector = TableDirector(tableView: tableView)
        interactor.startReceiveData()
    }

    func didStartingRefreshView() {
        interactor.updateData()
    }
}

// MARK: - OutputModule implementation
extension TobaccoListPresenter: AddTobaccoOutputModule {
    func sendChangedTobacco(_ tobacco: Tobacco) {
        interactor.receivedDataFromOutside(tobacco)
    }
}

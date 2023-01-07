//
//
//  ManufacturerListPresenter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 13.10.2022.
//
//

import Foundation
import TableKit

class ManufacturerListPresenter {
    // MARK: - Public properties
    weak var view: ManufacturerListViewInputProtocol!
    var interactor: ManufacturerListInteractorInputProtocol!
    var router: ManufacturerListRouterProtocol!

    // MARK: - Private properties
    private var tableDirector: TableDirector!

    // MARK: - Private methods
    private func createItem(for manufacturer: Manufacturer) -> ManufacturerListTableViewCellItem {
        ManufacturerListTableViewCellItem(name: manufacturer.name,
                                          country: manufacturer.country,
                                          image: manufacturer.image)
    }
    private func createRow(at item: ManufacturerListTableViewCellItem) -> Row {
        TableRow<ManufacturerListTableViewCell>(item: item).on(.click) { [weak self] options in
            self?.interactor.receiveDataForShowDetail(by: options.indexPath.row)
        }
    }

    private func setupContentView(_ manufacturers: [Manufacturer]) {
        tableDirector.clear()
        var rows: [Row] = []

        for manufacturer in manufacturers {
            let item = createItem(for: manufacturer)
            let row = createRow(at: item)
            rows.append(row)
        }

        let section = TableSection(rows: rows)
        section.headerHeight = 0.0
        section.footerHeight = 0.0
        tableDirector += section
        reloadData()
    }

    private func updateContentView(_ manufacturer: Manufacturer, at index: Int) {
        let item = createItem(for: manufacturer)
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
extension ManufacturerListPresenter: ManufacturerListInteractorOutputProtocol {
    func receivedManufacturersSuccess(with data: [Manufacturer]) {
        setupContentView(data)
        view.endRefreshing()
    }

    func receivedError(with message: String) {
        router.showError(with: message)
    }

    func receivedUpdate(for manufacturer: Manufacturer, at index: Int) {
        updateContentView(manufacturer, at: index)
    }

    func receivedDataForShowDetail(_ manudacturer: Manufacturer) {
        router.showDetail(for: manudacturer)
    }

    func receivedDataForEditing(_ manufacturer: Manufacturer) {
        router.showAddManufacturer(manufacturer, delegate: self)
    }
}

// MARK: - ViewOutputProtocol implementation
extension ManufacturerListPresenter: ManufacturerListViewOutputProtocol {
    func viewDidLoad() {
        let tableView = view.getTableView()
        let cellHeightCalculator = ManufacturerListCellHeightCalculator(tableView: tableView, countCellInView: 8)
        tableDirector = TableDirector(tableView: tableView,
                                      cellHeightCalculator: cellHeightCalculator)
        interactor.startReceiveData()
    }

    func didStartingRefreshView() {
        interactor.updateData()
    }
}

// MARK: - OutputModule implementation
extension ManufacturerListPresenter: AddManufacturerOutputModule {
    func sendChangedManufacturer(_ manufacture: Manufacturer) {
        interactor.receivedDataFromOutside(manufacture)
    }
}

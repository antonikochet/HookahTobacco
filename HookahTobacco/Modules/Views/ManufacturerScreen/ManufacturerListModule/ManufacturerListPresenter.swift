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
import UIKit

class ManufacturerListPresenter {
    // MARK: - Public properties
    weak var view: ManufacturerListViewInputProtocol!
    var interactor: ManufacturerListInteractorInputProtocol!
    var router: ManufacturerListRouterProtocol!

    // MARK: - Private properties
    private var tableDirector: TableDirector?
    private var isDownloadData: Bool = false

    // MARK: - Private methods
    private func createItem(for manufacturer: Manufacturer) -> ManufacturerListTableViewCellItem {
        ManufacturerListTableViewCellItem(name: manufacturer.name,
                                          country: manufacturer.country.name,
                                          image: manufacturer.image)
    }
    private func createRow(at item: ManufacturerListTableViewCellItem) -> Row {
        TableRow<ManufacturerListTableViewCell>(item: item).on(.click) { [weak self] options in
            self?.interactor.receiveDataForShowDetail(by: options.indexPath.row)
        }
    }

    private func setupContentView(_ manufacturers: [Manufacturer]) {
        guard let tableDirector else { return }
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
            self?.tableDirector?.reloadRow(at: indexPath, with: row)
        }
    }

    private func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableDirector?.reload()
        }
    }
}

// MARK: - InteractorOutputProtocol implementation
extension ManufacturerListPresenter: ManufacturerListInteractorOutputProtocol {
    func receivedManufacturersSuccess(with data: [Manufacturer]) {
        isDownloadData = true
        if data.isEmpty {
            view.showErrorView(title: R.string.localizable.manufacteurerListEmptyTitle(),
                               message: "",
                               buttonAction: nil)
        } else {
            setupContentView(data)
        }
        view.hideLoading()
        view.endRefreshing()
    }

    func receivedError(_ error: HTError) {
        view.hideLoading()
        view.endRefreshing()
        switch error {
        case .apiError, .databaseError:
            router.showError(with: error.message)
        case .noInternetConnection, .unexpectedError, .unknownError, .serverNotAvailable:
            if isDownloadData {
                router.showError(with: error.message)
            } else {
                view.showErrorView(isUnexpectedError: error != .noInternetConnection) { [weak self] in
                    self?.view.hideErrorView()
                    self?.interactor.startReceiveData()
                }
            }
        }
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
        tableDirector = TableDirector(tableView: tableView)
        view.showLoading()
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

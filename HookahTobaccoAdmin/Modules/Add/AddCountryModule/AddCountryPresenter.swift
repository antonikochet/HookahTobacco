//
//
//  AddCountryPresenter.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 06.08.2023.
//
//

import Foundation
import TableKit

class AddCountryPresenter {
    // MARK: - Public properties
    weak var view: AddCountryViewInputProtocol!
    var interactor: AddCountryInteractorInputProtocol!
    var router: AddCountryRouterProtocol!
    weak var delegate: AddCountryOutputModule?

    // MARK: - Private properties
    private var tableDirector: TableDirector?
    private var editingCountry: Country?

    // MARK: - Private methods
    private func setupContentTableView(_ counties: [Country]) {
        guard let tableDirector else { return }
        tableDirector.clear()
        var rows: [Row] = []

        for country in counties {
            let item = AddCountryTableViewCellItem(country: country)
            let row = TableRow<AddCountryTableViewCell>(item: item).on(.click) { [weak self] options in
                guard let self else { return }
                self.editingCountry = options.item.country
                self.view.showAddView(text: options.item.country.name,
                                      titleButton: R.string.localizable.addCountryAddButtonEditTitle())
            }
            rows.append(row)
        }

        let section = TableSection(rows: rows)
        section.headerHeight = 0.0
        section.footerHeight = 0.0
        tableDirector += section
        reloadData()
    }

    private func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableDirector?.reload()
        }
    }
}

// MARK: - InteractorOutputProtocol implementation
extension AddCountryPresenter: AddCountryInteractorOutputProtocol {
    func receivedSuccessCountries(_ countries: [Country]) {
        view.hideLoading()
        setupContentTableView(countries)
    }

    func receivedError(with message: String) {
        view.hideLoading()
        router.showError(with: message)
    }

    func receivedError(_ error: HTError) {
        view.hideLoading()
        router.showError(with: error.message)
    }

    func receivedSuccessAddCountry(showWithNew countries: [Country]) {
        editingCountry = nil
        view.hideLoading()
        setupContentTableView(countries)
        router.showSuccess(delay: 2.0)
        view.hideAddView()
    }
}

// MARK: - ViewOutputProtocol implementation
extension AddCountryPresenter: AddCountryViewOutputProtocol {
    func viewDidLoad() {
        let tableView = view.getTableView()
        tableDirector = TableDirector(tableView: tableView)
        view.showBlockLoading()
        interactor.receiveStartingData()
    }

    func viewWillDisappear() {
        delegate?.send(interactor.receiveCountries())
    }

    func pressedAddButton() {
        view.showAddView(text: "", titleButton: R.string.localizable.addCountryAddButtonAddTitle())
    }

    func pressedAddNewButton(_ name: String) {
        guard !name.isEmpty else {
            router.showError(with: R.string.localizable.addCountryNameEmptyMessage())
            return
        }
        view.showBlockLoading()
        if let editingCountry {
            interactor.editCountry(name, with: editingCountry.uid)
        } else {
            interactor.addCountry(name)
        }
    }

    func pressedCloseAddView() {
        editingCountry = nil
        view.hideAddView()
    }
}

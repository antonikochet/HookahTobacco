//
//
//  AddTastePresenter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 15.11.2022.
//
//

import Foundation
import TableKit

class AddTastePresenter {
    // MARK: - Public properties
    weak var view: AddTasteViewInputProtocol!
    var interactor: AddTasteInteractorInputProtocol!
    var router: AddTasteRouterProtocol!

    // MARK: - Private properties
    private var tableDirector: TableDirector?
    private var selectedTypes: [TasteType] = []

    // MARK: - Private methods
    private func setupContentTypesTableView(_ types: [TasteType]) {
        guard let tableDirector else { return }
        tableDirector.clear()
        var rows: [Row] = []

        for type in types {
            let item = SelectTasteTypeTableViewCellItem(
                item: type,
                isSelected: selectedTypes.contains(where: { $0.uid == type.uid })
            )
            let row = TableRow<SelectTasteTypeTableViewCell>(item: item).on(.click) { [weak self] options in
                guard let self else { return }
                let selectedType = options.item.item
                if let index = self.selectedTypes.firstIndex(where: { $0.uid == selectedType.uid }) {
                    options.item.isSelected = false
                    self.selectedTypes.remove(at: index)
                } else {
                    options.item.isSelected = true
                    self.selectedTypes.append(selectedType)
                }
                self.reloadData()
            }
            rows.append(row)
        }

        let section = TableSection(rows: rows)
        section.headerHeight = 0.0
        section.footerHeight = 0.0
        tableDirector += section
        view.updateHeightTableView(CGFloat(rows.count) * 32.0)
        reloadData()
    }

    private func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableDirector?.reload()
        }
    }
}

// MARK: - InteractorOutputProtocol implementation
extension AddTastePresenter: AddTasteInteractorOutputProtocol {
    func initialData(taste: Taste, isEdit: Bool) {
        selectedTypes = taste.typeTaste
        view.setupContent(taste: taste.taste, addButtonText: isEdit ? "Изменить вкус": "Добавить вкус")
    }

    func receivedSuccessTypes(_ types: [TasteType]) {
        setupContentTypesTableView(types)
        view.hideProgressView()
    }

    func receivedSuccess(_ taste: Taste) {
        router.showSuccess(delay: 2.0) { [weak self] in
            self?.router.dismissView(taste)
        }
    }

    func receivedError(with message: String) {
        view.hideProgressView()
        router.showError(with: message)
    }
}

// MARK: - ViewOutputProtocol implementation
extension AddTastePresenter: AddTasteViewOutputProtocol {
    func viewDidLoad() {
        let tableView = view.getTableView()
        tableDirector = TableDirector(tableView: tableView)
        view.showProgressView()
        interactor.setupContent()
    }

    func didTouchAdded(taste: String) {
        guard !taste.isEmpty else {
            router.showError(with: "Название вкуса не введено")
            return
        }
        guard !selectedTypes.isEmpty else {
            router.showError(with: "Нужно выбрать хотя бы один тип вкуса")
            return
        }
        interactor.addTaste(nameTaste: taste, selectedTypes: selectedTypes)
    }
}

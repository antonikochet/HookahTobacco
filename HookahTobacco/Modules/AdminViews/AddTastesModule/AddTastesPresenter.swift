//
//
//  AddTastesPresenter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 12.11.2022.
//
//

import Foundation
import TableKit
import IVCollectionKit

class AddTastesPresenter {
    // MARK: - Public properties
    weak var view: AddTastesViewInputProtocol!
    var interactor: AddTastesInteractorInputProtocol!
    var router: AddTastesRouterProtocol!

    // MARK: - Private properties
    private var tableDirector: CustomTableDirector?
    private var tasteDirector: CustomCollectionDirector?
    private var selectedTastesViewModel: [TasteCollectionCellViewModel] = []

    // MARK: - Private methods
    private func createTasteTableRow(_ taste: Taste, isSelect: Bool) -> TableRow<AddTastesTableViewCell> {
        let item = AddTastesTableCellViewModel(taste: taste.taste,
                                    id: String(taste.uid),
                                    typeTaste: taste.typeTaste.first?.name ?? "",
                                    isSelect: isSelect)
        return TableRow<AddTastesTableViewCell>(item: item)
            .on(.click) { [weak self] options in
                self?.interactor.selectedTaste(by: options.item.taste)
            }
            .on(.canEdit) { _ in
                return true
            }
    }

    private func createSelectedTasteViewModel(_ taste: Taste) -> TasteCollectionCellViewModel {
        TasteCollectionCellViewModel(label: taste.taste)
    }

    private func setupAllTastesContent(_ tastes: [Taste], with selectedTastes: [Taste]) {
        guard let tableDirector else { return }
        tableDirector.clear()
        var rows: [Row] = []

        let selectedIdTastes: Set<Int> = Set(selectedTastes.map { $0.uid })

        for taste in tastes {
            let row = createTasteTableRow(taste, isSelect: selectedIdTastes.contains(taste.uid))
            rows.append(row)
        }

        tableDirector.customAction = { [weak self] row, action in
            if case .edit = action,
               let tableRow = row as? TableRow<AddTastesTableViewCell> {
                self?.interactor.receiveDataForEdit(by: tableRow.item.taste)
            }
        }

        let section = TableSection(rows: rows)
        section.headerHeight = 0.0
        section.footerHeight = 0.0
        tableDirector += section
        reloadData()
    }

    private func setupCollectionView(_ selectedTastes: [Taste]) {
        guard let tasteDirector else { return }
        tasteDirector.sections.removeAll()
        selectedTastesViewModel.removeAll()
        var rows: [AbstractCollectionItem] = []

        for taste in selectedTastes {
            let item = createSelectedTasteViewModel(taste)
            selectedTastesViewModel.append(item)
            let row = CollectionItem<TasteCollectionViewCell>(item: item)
            rows.append(row)
        }

        let section = CollectionSection(items: rows)

        tasteDirector += section
        tasteDirector.reload()
    }

    private func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableDirector?.reload()
        }
    }
}

// MARK: - InteractorOutputProtocol implementation
extension AddTastesPresenter: AddTastesInteractorOutputProtocol {
    func initialSelectedTastes(_ tastes: [Taste]) {
        setupCollectionView(tastes)
    }

    func initialAllTastes(_ tastes: [Taste], with selectedTastes: [Taste]) {
        setupAllTastesContent(tastes, with: selectedTastes)
        setupCollectionView(selectedTastes)
    }

    func receivedError(_ error: HTError) {
        router.showError(with: error.message)
    }

    func updateData(by index: Int, with taste: Taste, and selectedTastes: [Taste]) {
        let selectedIdTastes = Set(selectedTastes.map { $0.uid })
        setupCollectionView(selectedTastes)
        let row = createTasteTableRow(taste, isSelect: selectedIdTastes.contains(taste.uid))
        let indexPath = IndexPath(row: index, section: 0)
        tableDirector?.reloadRow(at: indexPath, with: row)
    }

    func receivedDataForEdit(editTaste: Taste) {
        router.showAddTaste(taste: editTaste,
                            outputModule: self)
    }

    func receivedSelectedTastes(_ selectedTastes: [Taste]) {
        router.dismissView(newSelectedTastes: selectedTastes)
    }
}

// MARK: - ViewOutputProtocol implementation
extension AddTastesPresenter: AddTastesViewOutputProtocol {
    func viewDidLoad() {
        let tableView = view.getTableView()
        tableDirector = CustomTableDirector(tableView: tableView)
        let collectionView = view.getSelectCollectionView()
        tasteDirector = CustomCollectionDirector(collectionView: collectionView)
        interactor.receiveStartingDataView()
    }

    func didTouchAdd() {
        router.showAddTaste(taste: nil, outputModule: self)
    }

    func selectedTastesDone() {
        interactor.receiveSelectedTastes()
    }

    func didStartSearch(with text: String) {
        interactor.performSearch(with: text)
    }

    func didEndSearch() {
        interactor.endSearch()
    }
}

extension AddTastesPresenter: AddTasteOutputModule {
    func sendTaste(_ taste: Taste) {
        interactor.addTaste(taste)
    }
}

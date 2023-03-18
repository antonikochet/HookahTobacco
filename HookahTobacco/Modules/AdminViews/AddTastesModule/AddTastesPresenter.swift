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
    private var tableDirector: TableDirector?
    private var tasteDirector: CollectionDirector?
    private var allTastesViewModel: [AddTastesTableCellViewModel] = []
    private var selectedTastesViewModel: [TasteCollectionCellViewModel] = []

    // MARK: - Private methods
    private func createTasteViewModel(_ taste: Taste, isSelect: Bool) -> AddTastesTableCellViewModel {
        AddTastesTableCellViewModel(taste: taste.taste,
                                    typeTaste: taste.typeTaste,
                                    isSelect: isSelect)
    }

    private func createSelectedTasteViewModel(_ taste: Taste) -> TasteCollectionCellViewModel {
        TasteCollectionCellViewModel(label: taste.taste)
    }

    private func createTasteRow(at item: AddTastesTableCellViewModel) -> Row {
        TableRow<AddTastesTableViewCell>(item: item).on(.click) { [weak self] options in
            let name = options.item.taste
            self?.interactor.selectedTaste(by: name)
        }
    }

    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tasteDirector?.reload()
        }
    }

    private func reloadTasteView() {
        DispatchQueue.main.async {
            self.tasteDirector?.reload()
        }
    }

    private func setupTableView(_ allTastes: [Taste], with selectedTastes: [Taste]) {
        guard let tableDirector else { return }
        tableDirector.clear()
        allTastesViewModel.removeAll()
        var rows: [Row] = []

        let selectedIdTastes: Set<String> = Set(selectedTastes.map { $0.uid })
        for taste in allTastes {
            let item = createTasteViewModel(taste, isSelect: selectedIdTastes.contains(taste.uid))
            allTastesViewModel.append(item)
            let row = createTasteRow(at: item)
            rows.append(row)
        }

        let section = TableSection(headerView: nil, footerView: nil, rows: rows)
        section.headerHeight = 0.0
        section.footerHeight = 0.0
        tableDirector += section
        tableDirector.reload()
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

    private func updateContentView(by index: Int, with taste: Taste, and selectedTastes: [Taste]) {
        guard allTastesViewModel.count > index else { return }
        let selectedIdTastes = Set(selectedTastes.map { $0.uid })
        let item = createTasteViewModel(taste, isSelect: selectedIdTastes.contains(taste.uid))
        allTastesViewModel[index] = item
        setupCollectionView(selectedTastes)
        let indexPath = IndexPath(row: index, section: 0)
        let row = createTasteRow(at: item)
        DispatchQueue.main.async { [weak self] in
            self?.tableDirector?.reloadRow(at: indexPath, with: row)
        }
    }
}

// MARK: - InteractorOutputProtocol implementation
extension AddTastesPresenter: AddTastesInteractorOutputProtocol {
    func initialSelectedTastes(_ tastes: [Taste]) {
        setupCollectionView(tastes)
    }

    func initialAllTastes(_ tastes: [Taste], with selectedTastes: [Taste]) {
        setupTableView(tastes, with: selectedTastes)
        setupCollectionView(selectedTastes)
    }

    func receivedError(with message: String) {
        router.showError(with: message)
    }

    func updateData(by index: Int, with taste: Taste, and selectedTastes: [Taste]) {
        updateContentView(by: index, with: taste, and: selectedTastes)
    }

    func receivedDataForEdit(editTaste: Taste) {
        router.showAddTaste(taste: editTaste, outputModule: self)
    }

    func receivedSelectedTastes(_ selectedTastes: [Taste]) {
        router.dismissView(newSelectedTastes: selectedTastes)
    }
}

// MARK: - ViewOutputProtocol implementation
extension AddTastesPresenter: AddTastesViewOutputProtocol {
    func viewDidLoad() {
        let tableView = view.getTableView()
        if let tasteCollectionView = view.getTasteCollectionView() as? TasteCollectionView {
            tasteCollectionView.getItem = { [weak self] index -> TasteCollectionCellViewModel? in
                guard let self = self else { return nil }
                guard index < self.selectedTastesViewModel.count else { return nil }
                return self.selectedTastesViewModel[index]
            }
            tasteDirector = CollectionDirector(collectionView: tasteCollectionView)
        }
        tableDirector = TableDirector(tableView: tableView)
        interactor.receiveStartingDataView()
    }

    func didTouchAdd() {
        router.showAddTaste(taste: nil, outputModule: self)
    }

    func selectedTastesDone() {
        interactor.receiveSelectedTastes()
    }

    func didEditingTaste(by index: Int) {
        let viewModel = allTastesViewModel[index]
        interactor.receiveDataForEdit(by: viewModel.taste)
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

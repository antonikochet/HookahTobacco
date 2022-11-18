//
//
//  AddTastesPresenter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 12.11.2022.
//
//

import Foundation

class AddTastesPresenter {
    // MARK: - Public properties
    weak var view: AddTastesViewInputProtocol!
    var interactor: AddTastesInteractorInputProtocol!
    var router: AddTastesRouterProtocol!

    // MARK: - Private properties
    private var allTastesViewModel: [AddTastesTableCellViewModel] = []
    private var selectedViewModels: [TasteCollectionCellViewModel] = []

    // MARK: - Private methods
    private func createTasteViewModel(_ taste: Taste, isSelect: Bool) -> AddTastesTableCellViewModel {
        AddTastesTableCellViewModel(taste: taste.taste,
                                    id: String(taste.id),
                                    typeTaste: taste.typeTaste,
                                    isSelect: isSelect)
    }
    
    private func createSelectedTasteViewModel(_ taste: Taste) -> TasteCollectionCellViewModel {
        TasteCollectionCellViewModel(taste: taste.taste)
    }
}

// MARK: - InteractorOutputProtocol implementation
extension AddTastesPresenter: AddTastesInteractorOutputProtocol {
    func initialSelectedTastes(_ tastes: [Taste]) {
        selectedViewModels = tastes.map {
            createSelectedTasteViewModel($0)
        }
        view.setupContent()
    }

    func initialAllTastes(_ tastes: [Taste], with selectedTastes: [Taste]) {
        let selectedIdTastes: Set<Int> = Set(selectedTastes.map { $0.id })
        allTastesViewModel = tastes.map { taste in
            return createTasteViewModel(taste, isSelect: selectedIdTastes.contains(taste.id))
        }
        view.setupContent()
    }
    
    func receivedError(with message: String) {
        view.showError(with: message)
    }
    
    func updateData(by index: Int, with taste: Taste, and selectedTastes: [Taste]) {
        let selectedIdTastes = Set(selectedTastes.map { $0.id })
        allTastesViewModel[index] = createTasteViewModel(taste, isSelect: selectedIdTastes.contains(taste.id))
        selectedViewModels = selectedTastes.map {
            createSelectedTasteViewModel($0)
        }
        view.updateRowAndSelect(by: index)
    }

    func receivedDataForAdd(_ allIdsTaste: Set<Int>) {
        router.showAddTaste(taste: nil,
                            allIdsTaste: allIdsTaste,
                            outputModule: self)
    }

    func receivedDataForEdit(editTaste: Taste, allIdsTaste: Set<Int>) {
        router.showAddTaste(taste: editTaste,
                            allIdsTaste: allIdsTaste,
                            outputModule: self)
    }
    
    func receivedSelectedTastes(_ selectedTastes: [Taste]) {
        router.dismissView(newSelectedTastes: selectedTastes)
    }
}

// MARK: - ViewOutputProtocol implementation
extension AddTastesPresenter: AddTastesViewOutputProtocol {
    func viewDidLoad() {
        interactor.receiveStartingDataView()
    }
    
    var selectedNumberOfRows: Int {
        selectedViewModels.count
    }

    func getSelectedViewModel(by index: Int) -> TasteCollectionCellViewModel {
        selectedViewModels[index]
    }
    
    var tastesNumberOfRows: Int {
        allTastesViewModel.count
    }

    func getViewModel(by index: Int) -> AddTastesTableCellViewModel {
        allTastesViewModel[index]
    }
    
    func didSelectTaste(by index: Int) {
        let viewModel = allTastesViewModel[index]
        interactor.selectedTaste(by: viewModel.taste)
    }
    
    func didTouchAdd() {
        interactor.receiveDataForAdd()
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

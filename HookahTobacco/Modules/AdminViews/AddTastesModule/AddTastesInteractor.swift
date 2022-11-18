//
//
//  AddTastesInteractor.swift
//  HookahTobacco
//
//  Created by антон кочетков on 12.11.2022.
//
//

import Foundation

typealias SelectedTastes = Dictionary<Int, Taste>

protocol AddTastesInteractorInputProtocol: AnyObject {
    func receiveStartingDataView()
    func receiveDataForAdd()
    func receiveDataForEdit(by taste: String)
    func selectedTaste(by taste: String)
    func addTaste(_ taste: Taste)
    func receiveSelectedTastes()
    func performSearch(with text: String)
    func endSearch() 
}

protocol AddTastesInteractorOutputProtocol: AnyObject {
    func initialSelectedTastes(_ tastes: [Taste])
    func initialAllTastes(_ tastes: [Taste], with selectedTastes: [Taste])
    func receivedError(with message: String)
    func updateData(by index: Int, with taste: Taste, and selectedTastes: [Taste])
    func receivedDataForAdd(_ allIdsTaste: Set<Int>)
    func receivedDataForEdit(editTaste: Taste, allIdsTaste: Set<Int>)
    func receivedSelectedTastes(_ selectedTastes: [Taste])
}

class AddTastesInteractor {
    // MARK: - Public properties
    weak var presenter: AddTastesInteractorOutputProtocol!

    // MARK: - Dependency
    private let getDataManager: GetDataBaseNetworkingProtocol

    // MARK: - Private properties
    private var selectedTastes: SelectedTastes
    private var allTastes: [Taste] = []
    private var filterTastes: [Taste] = []

    // MARK: - Initializers
    init(selectedTastes: SelectedTastes,
         getDataManager: GetDataBaseNetworkingProtocol) {
        self.selectedTastes = selectedTastes
        self.getDataManager = getDataManager
    }

    // MARK: - Private methods
    private func receiveAllTastes() {
        getDataManager.getAllTastes { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let data):
                    self.allTastes = data.sorted(by: { $0.id < $1.id })
                    self.presenter.initialAllTastes(self.allTastes, with: self.sortedSelectedTastes())
                case .failure(let error):
                    self.presenter.receivedError(with: error.localizedDescription)
            }
        }
    }
    
    private func sortedSelectedTastes() -> [Taste] {
        return Array(selectedTastes.values.sorted(by: { $0.id < $1.id }))
    }
}
// MARK: - InputProtocol implementation 
extension AddTastesInteractor: AddTastesInteractorInputProtocol {
    func receiveStartingDataView() {
        receiveAllTastes()
        presenter.initialSelectedTastes(sortedSelectedTastes())
    }

    func receiveDataForAdd() {
        let allIdsTaste = Set(allTastes.map { $0.id })
        presenter.receivedDataForAdd(allIdsTaste)
    }

    func receiveDataForEdit(by taste: String) {
        guard let taste = allTastes.first(where: { $0.taste == taste }) else { return }
        let allIdsTaste = Set(allTastes.map { $0.id })
        presenter.receivedDataForEdit(editTaste: taste,
                                      allIdsTaste: allIdsTaste)
    }

    func selectedTaste(by taste: String) {
        let slctTastes = filterTastes.isEmpty ? allTastes : filterTastes
        guard let index = slctTastes.firstIndex(where: { $0.taste == taste }) else { return }
        let taste = slctTastes[index]
        if selectedTastes[taste.id] != nil {
            selectedTastes.removeValue(forKey: taste.id)
        } else {
            selectedTastes.updateValue(taste, forKey: taste.id)
        }
        presenter.updateData(by: index, with: taste, and: sortedSelectedTastes())
    }
    
    func addTaste(_ taste: Taste) {
        if let index = allTastes.firstIndex(where: { $0.id == taste.id }) {
            allTastes[index] = taste
        } else {
            allTastes.append(taste)
        }
        presenter.initialAllTastes(allTastes, with: sortedSelectedTastes())
    }
    
    func receiveSelectedTastes() {
        presenter.receivedSelectedTastes(Array(selectedTastes.values))
    }
    
    func performSearch(with text: String) {
        guard !text.isEmpty else {
            filterTastes = []
            return
        }
        let lcText = text.lowercased()
        filterTastes = allTastes
            .filter { $0.taste.lowercased().contains(lcText) }
        presenter.initialAllTastes(filterTastes, with: sortedSelectedTastes())
    }
    
    func endSearch() {
        filterTastes = []
        presenter.initialAllTastes(allTastes,
                                   with: sortedSelectedTastes())
    }
}

//
//
//  AddTastesInteractor.swift
//  HookahTobacco
//
//  Created by антон кочетков on 12.11.2022.
//
//

import Foundation

typealias SelectedTastes = [String: Taste]

protocol AddTastesInteractorInputProtocol: AnyObject {
    func receiveStartingDataView()
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
    func receivedDataForEdit(editTaste: Taste)
    func receivedSelectedTastes(_ selectedTastes: [Taste])
}

class AddTastesInteractor {
    // MARK: - Public properties
    weak var presenter: AddTastesInteractorOutputProtocol!

    // MARK: - Dependency
    private let getDataManager: GetDataNetworkingServiceProtocol

    // MARK: - Private properties
    private var selectedTastes: SelectedTastes {
        didSet {
            sortedSelectedTastes = Array(selectedTastes.values.sorted(by: { $0.uid < $1.uid }))
        }
    }
    private var allTastes: [Taste] = []
    private var filterTastes: [Taste] = []
    private var sortedSelectedTastes: [Taste]

    // MARK: - Initializers
    init(selectedTastes: SelectedTastes,
         getDataManager: GetDataNetworkingServiceProtocol) {
        self.selectedTastes = selectedTastes
        self.getDataManager = getDataManager
        self.sortedSelectedTastes = Array(selectedTastes.values.sorted(by: { $0.taste < $1.taste }))
    }

    // MARK: - Private methods
    private func receiveAllTastes() {
        getDataManager.getAllTastes { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.allTastes = data.sorted(by: { $0.taste < $1.taste })
                self.presenter.initialAllTastes(self.allTastes, with: self.sortedSelectedTastes)
            case .failure(let error):
                self.presenter.receivedError(with: error.localizedDescription)
            }
        }
    }
}
// MARK: - InputProtocol implementation 
extension AddTastesInteractor: AddTastesInteractorInputProtocol {
    func receiveStartingDataView() {
        receiveAllTastes()
        presenter.initialSelectedTastes(sortedSelectedTastes)
    }

    func receiveDataForEdit(by taste: String) {
        guard let taste = allTastes.first(where: { $0.taste == taste }) else { return }
        presenter.receivedDataForEdit(editTaste: taste)
    }

    func selectedTaste(by taste: String) {
        let slctTastes = filterTastes.isEmpty ? allTastes : filterTastes
        guard let index = slctTastes.firstIndex(where: { $0.taste == taste }) else { return }
        let taste = slctTastes[index]
        if selectedTastes[taste.uid] != nil {
            selectedTastes.removeValue(forKey: taste.uid)
        } else {
            selectedTastes.updateValue(taste, forKey: taste.uid)
        }
        presenter.updateData(by: index, with: taste, and: sortedSelectedTastes)
    }

    func addTaste(_ taste: Taste) {
        if let index = allTastes.firstIndex(where: { $0.uid == taste.uid }) {
            allTastes[index] = taste
        } else {
            allTastes.append(taste)
        }
        presenter.initialAllTastes(allTastes, with: sortedSelectedTastes)
    }

    func receiveSelectedTastes() {
        presenter.receivedSelectedTastes(Array(selectedTastes.values))
    }

    func performSearch(with text: String) {
        guard !text.isEmpty else {
            filterTastes = []
            presenter.initialAllTastes(allTastes, with: sortedSelectedTastes)
            return
        }
        let lcText = text.lowercased()
        filterTastes = allTastes
            .filter { $0.taste.lowercased().contains(lcText) }
        presenter.initialAllTastes(filterTastes, with: sortedSelectedTastes)
    }

    func endSearch() {
        filterTastes = []
        presenter.initialAllTastes(allTastes,
                                   with: sortedSelectedTastes)
    }
}

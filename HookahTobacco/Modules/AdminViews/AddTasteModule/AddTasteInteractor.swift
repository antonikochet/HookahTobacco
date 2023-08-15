//
//
//  AddTasteInteractor.swift
//  HookahTobacco
//
//  Created by антон кочетков on 15.11.2022.
//
//

import Foundation

protocol AddTasteInteractorInputProtocol: AnyObject {
    func setupContent()
    func addTaste(nameTaste: String, selectedTypes: [TasteType])
    func addType(newType: String)
}

protocol AddTasteInteractorOutputProtocol: AnyObject {
    func initialData(taste: Taste, isEdit: Bool)
    func receivedSuccessTypes(_ types: [TasteType])
    func receivedSuccessNewType()
    func receivedSuccess(_ taste: Taste)
    func receivedError(with message: String)
}

class AddTasteInteractor {
    // MARK: - Public properties
    weak var presenter: AddTasteInteractorOutputProtocol!

    // MARK: - Dependency
    private let getDataManager: DataManagerProtocol
    private let setDataManager: AdminDataManagerProtocol

    // MARK: - Private properties
    private var taste: Taste?
    private var tasteTypes: [TasteType] = []

    // MARK: - Initializers
    init(_ taste: Taste?,
         getDataManager: DataManagerProtocol,
         setDataManager: AdminDataManagerProtocol) {
        self.taste = taste
        self.getDataManager = getDataManager
        self.setDataManager = setDataManager
    }

    // MARK: - Private methods
    private func receiveType() {
        getDataManager.receiveData(typeData: TasteType.self) { [weak self] result in
            switch result {
            case .success(let types):
                self?.tasteTypes = types
                self?.presenter.receivedSuccessTypes(types)
            case .failure(let error):
                self?.presenter.receivedError(with: error.localizedDescription)
            }
        }
    }

    private func addTaste(_ taste: Taste) {
        setDataManager.addData(taste) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let newTaste):
                self.presenter.receivedSuccess(newTaste)
            case .failure(let error):
                self.presenter.receivedError(with: error.localizedDescription)
            }
        }
    }

    private func editTaste(_ taste: Taste) {
        setDataManager.setData(taste) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let taste):
                self.presenter.receivedSuccess(taste)
            case .failure(let error):
                self.presenter.receivedError(with: error.localizedDescription)
            }
        }
    }

    private func addTypeToServer(_ newType: String) {
        let type = TasteType(name: newType)
        setDataManager.addData(type) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let newType):
                self.tasteTypes.append(newType)
                self.presenter.receivedSuccessTypes(self.tasteTypes)
                self.presenter.receivedSuccessNewType()
            case .failure(let error):
                self.presenter.receivedError(with: error.localizedDescription)
            }
        }
    }
}
// MARK: - InputProtocol implementation 
extension AddTasteInteractor: AddTasteInteractorInputProtocol {
    func setupContent() {
        if let taste {
            presenter.initialData(taste: taste, isEdit: true)
        } else {
            let taste = Taste(uid: -1, taste: "", typeTaste: [])
            presenter.initialData(taste: taste, isEdit: false)
        }
        receiveType()
    }

    func addTaste(nameTaste: String, selectedTypes: [TasteType]) {
        if let taste {
            let taste = Taste(uid: taste.uid,
                              taste: nameTaste,
                              typeTaste: selectedTypes)
            editTaste(taste)
        } else {
            let taste = Taste(uid: -1, taste: nameTaste, typeTaste: selectedTypes)
            addTaste(taste)
        }
    }

    func addType(newType: String) {
        addTypeToServer(newType)
    }
}

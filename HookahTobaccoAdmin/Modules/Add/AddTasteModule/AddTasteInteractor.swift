//
//
//  AddTasteInteractor.swift
//  HookahTobaccoAdmin
//
//  Created by антон кочетков on 15.11.2022.
//
//

import Foundation
import HookahTobaccoCore
import HookahTobaccoCoreAdmin

protocol AddTasteInteractorInputProtocol: AnyObject {
    func setupContent()
    func addTaste(nameTaste: String, selectedTypes: [TasteType])
    func addType(newType: String)
}

protocol AddTasteInteractorOutputProtocol: PresenterrProtocol {
    func initialData(taste: Taste, isEdit: Bool)
    func receivedSuccessTypes(_ types: [TasteType])
    func receivedSuccessNewType()
    func receivedSuccess(_ taste: Taste)
}

class AddTasteInteractor {
    // MARK: - Public properties
    weak var presenter: AddTasteInteractorOutputProtocol!

    // MARK: - Dependency
    private let tasteRepo: TasteRepoProtocol
    private let tasteTypeRepo: TasteTypeRepoProtocol
    private let adminTasteRepo: AdminTasteRepoProtocol
    private let adminTasteTypeRepo: AdminTasteTypeRepoProtocol

    // MARK: - Private properties
    private var taste: Taste?
    private var tasteTypes: [TasteType] = []

    // MARK: - Initializers
    init(_ taste: Taste?,
         tasteRepo: TasteRepoProtocol,
         tasteTypeRepo: TasteTypeRepoProtocol,
         adminTasteRepo: AdminTasteRepoProtocol,
         adminTasteTypeRepo: AdminTasteTypeRepoProtocol) {
        self.taste = taste
        self.tasteRepo = tasteRepo
        self.tasteTypeRepo = tasteTypeRepo
        self.adminTasteRepo = adminTasteRepo
        self.adminTasteTypeRepo = adminTasteTypeRepo
    }

    // MARK: - Private methods
    private func receiveType() {
        tasteTypeRepo.fetchTasteType { [weak self] result in
            switch result {
            case .success(let types):
                self?.tasteTypes = types
                self?.presenter.receivedSuccessTypes(types)
            case .failure(let error):
                self?.presenter.receivedError(error)
            }
        }
    }

    private func addTaste(_ taste: Taste) {
        adminTasteRepo.create(taste: taste) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let newTaste):
                self.presenter.receivedSuccess(newTaste)
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
    }

    private func editTaste(_ taste: Taste) {
        adminTasteRepo.update(taste: taste) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let taste):
                self.presenter.receivedSuccess(taste)
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
    }

    private func addTypeToServer(_ newType: String) {
        let type = TasteType(name: newType)
        adminTasteTypeRepo.create(tasteType: type) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let newType):
                self.tasteTypes.append(newType)
                self.presenter.receivedSuccessTypes(self.tasteTypes)
                self.presenter.receivedSuccessNewType()
            case .failure(let error):
                self.presenter.receivedError(error)
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
            let taste = Taste(taste: "", typeTaste: [])
            presenter.initialData(taste: taste, isEdit: false)
        }
        receiveType()
    }

    func addTaste(nameTaste: String, selectedTypes: [TasteType]) {
        if let taste {
            let taste = Taste(id: taste.id,
                              taste: nameTaste,
                              typeTaste: selectedTypes)
            editTaste(taste)
        } else {
            let taste = Taste(taste: nameTaste, typeTaste: selectedTypes)
            addTaste(taste)
        }
    }

    func addType(newType: String) {
        addTypeToServer(newType)
    }
}

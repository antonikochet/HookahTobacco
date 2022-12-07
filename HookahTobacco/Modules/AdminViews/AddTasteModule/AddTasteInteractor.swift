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
    func addTaste(taste: String, type: String)
}

protocol AddTasteInteractorOutputProtocol: AnyObject {
    func initialData(taste: Taste)
    func receivedSuccess(_ taste: Taste)
    func receivedError(with message: String)
}

class AddTasteInteractor {
    // MARK: - Public properties
    weak var presenter: AddTasteInteractorOutputProtocol!

    // MARK: - Dependency
    private let setDataManager: AdminDataManagerProtocol

    // MARK: - Private properties
    private var taste: Taste?
    private var isEditing: Bool

    // MARK: - Initializers
    init(_ taste: Taste?,
         setDataManager: AdminDataManagerProtocol) {
        self.isEditing = taste != nil
        self.taste = taste
        self.setDataManager = setDataManager
    }

    // MARK: - Private methods
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
        setDataManager.setData(taste) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.presenter.receivedError(with: error.localizedDescription)
            } else {
                self.presenter.receivedSuccess(taste)
            }
        }
    }
}
// MARK: - InputProtocol implementation 
extension AddTasteInteractor: AddTasteInteractorInputProtocol {
    func setupContent() {
        if let taste = taste {
            presenter.initialData(taste: taste)
        } else {
            let taste = Taste(uid: "", taste: "", typeTaste: "")
            presenter.initialData(taste: taste)
        }
    }

    func addTaste(taste: String, type: String) {
        if isEditing {
            let taste = Taste(uid: self.taste?.uid ?? "",
                              taste: taste,
                              typeTaste: type)
            editTaste(taste)
        } else {
            let taste = Taste(uid: "", taste: taste, typeTaste: type)
            addTaste(taste)
        }
    }
}

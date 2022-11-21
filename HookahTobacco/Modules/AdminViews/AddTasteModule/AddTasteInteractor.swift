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
    private let setDataManager: SetDataNetworkingServiceProtocol

    // MARK: - Private properties
    private var taste: Taste?
    private var allIdsTaste: Set<Int>
    private var isEditing: Bool
    private var id: Int {
        (allIdsTaste.max() ?? -2) + 1
    }

    // MARK: - Initializers
    init(_ taste: Taste?,
         allIdsTaste: Set<Int>,
         setDataManager: SetDataNetworkingServiceProtocol) {
        self.isEditing = taste != nil
        self.taste = taste
        self.allIdsTaste = allIdsTaste
        self.setDataManager = setDataManager
    }

    // MARK: - Private methods
    private func addTaste(_ taste: Taste) {
        setDataManager.addTaste(taste) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.presenter.receivedError(with: error.localizedDescription)
            } else {
                self.presenter.receivedSuccess(taste)
            }
        }
    }
    
    private func editTaste(_ taste: Taste) {
        setDataManager.setTaste(taste) { [weak self] error in
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
            let taste = Taste(id: id, taste: "", typeTaste: "")
            presenter.initialData(taste: taste)
        }
    }
    
    func addTaste(taste: String, type: String) {
        if isEditing {
            if let id = self.taste?.id {
                let taste = Taste(id: id,
                                  taste: taste,
                                  typeTaste: type)
                editTaste(taste)
            }
        } else {
            let taste = Taste(id: id, taste: taste, typeTaste: type)
            addTaste(taste)
        }
    }
}

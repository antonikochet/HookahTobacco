//
//
//  AddTastePresenter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 15.11.2022.
//
//

import Foundation

class AddTastePresenter {
    // MARK: - Public properties
    weak var view: AddTasteViewInputProtocol!
    var interactor: AddTasteInteractorInputProtocol!
    var router: AddTasteRouterProtocol!

    // MARK: - Private properties

    // MARK: - Private methods

}

// MARK: - InteractorOutputProtocol implementation
extension AddTastePresenter: AddTasteInteractorOutputProtocol {
    func initialData(taste: Taste) {
        view.setupContent(taste: taste.taste,
                          type: taste.typeTaste)
    }

    func receivedSuccess(_ taste: Taste) {
        router.showSuccess(delay: 2.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.router.dismissView(taste)
        }
    }

    func receivedError(with message: String) {
        router.showError(with: message)
    }
}

// MARK: - ViewOutputProtocol implementation
extension AddTastePresenter: AddTasteViewOutputProtocol {
    func viewDidLoad() {
        interactor.setupContent()
    }

    func didTouchAdded(taste: String?, type: String?) {
        guard let taste = taste, !taste.isEmpty else {
            router.showError(with: "Название вкуса не введено")
            return
        }
        guard let type = type, !type.isEmpty else {
            router.showError(with: "Тип вкуса не введен")
            return
        }
        interactor.addTaste(taste: taste, type: type)
    }
}

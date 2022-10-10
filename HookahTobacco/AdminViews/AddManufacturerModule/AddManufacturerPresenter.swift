//
//
//  AddManufacturerPresenter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import Foundation

class AddManufacturerPresenter {
    weak var view: AddManufacturerViewInputProtocol!
    var interactor: AddManufacturerInteractorInputProtocol!
    var router: AddManufacturerRouterProtocol!
}

extension AddManufacturerPresenter: AddManufacturerInteractorOutputProtocol {
    func receivedSuccessWhileAdding() {
        view.showSuccessViewAlert()
    }
    
    func receivedErrorWhileAdding(with code: Int, and message: String) {
        view.showAlertError(with: "Code - \(code). \(message)")
    }
}

extension AddManufacturerPresenter: AddManufacturerViewOutputProtocol {
    func pressedAddButton(with enteredData: AddManufacturerEntity.EnterData) {
        guard let name = enteredData.name, !name.isEmpty else {
            view.showAlertForUnspecifiedField(with: "Ошибка",
                                              message: "Название производства не введено, поле является обязательным!")
            return
        }
        guard let country = enteredData.country, !country.isEmpty else {
            view.showAlertForUnspecifiedField(with: "Ошибка",
                                              message: "Страна произовдителя не введена, поле является обязательным!")
            return
        }
        
        let data = AddManufacturerEntity.Manufacturer(name: name,
                                country: country,
                                description: enteredData.description)
        
        interactor.sendNewManufacturerToServer(data)
    }
}

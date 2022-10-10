//
//
//  AddTobaccoPresenter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import Foundation

class AddTobaccoPresenter {
    weak var view: AddTobaccoViewInputProtocol!
    var interactor: AddTobaccoInteractorInputProtocol!
    var router: AddTobaccoRouterProtocol!
    
    private var manufacturerSelectItems: [String] = ["-"]
}

extension AddTobaccoPresenter: AddTobaccoInteractorOutputProtocol {
    func receivedSuccessWhileAdding() {
        view.showSuccessViewAlert()
    }
    
    func receivedErrorWhileAdding(with code: Int, and message: String) {
        view.showAlertError(with: "Code - \(code). \(message)")
    }
    
    func receivedError(with title: String, and message: String) {
        view.showAlertForUnspecifiedField(with: title, message: message)
    }
    
    func showNameManufacturersForSelect(_ names: [String]) {
        manufacturerSelectItems = names
        manufacturerSelectItems.insert("-", at: 0)
    }
}

extension AddTobaccoPresenter: AddTobaccoViewOutputProtocol {
    func pressedButtonAdded(with data: AddTobaccoEntity.EnteredData) {
        guard let name = data.name, !name.isEmpty else {
            view.showAlertForUnspecifiedField(with: "Ошибка",
                                              message: "Название табака не введено, поле является обязательным!")
            return
        }
        guard let tastes = data.tastes, !tastes.isEmpty else {
            view.showAlertForUnspecifiedField(with: "Ошибка", message: "Вкусы табака отсутсвуют, поле является обязательным!")
            return
        }
        
        let taste = tastes.replacingOccurrences(of: "\\s*",
                                          with: "",
                                          options: [.regularExpression])
                            .split(separator: ",")
                            .map { String($0) }
        let description = data.description ?? ""
        let tobaccoInteractor = AddTobaccoEntity.Tobacco(name: name,
                                                         tastes: taste,
                                                         description: description)
        interactor.sendNewTobaccoToServer(tobaccoInteractor)
    }
    
    func didSelectedManufacturer(by index: Int) {
        guard !manufacturerSelectItems.isEmpty else { return }
        interactor.didSelectedManufacturer(manufacturerSelectItems[index])
    }
    
    var numberOfRows: Int {
        manufacturerSelectItems.count
    }
    
    func receiveRow(by index: Int) -> String {
        manufacturerSelectItems[index]
    }
}

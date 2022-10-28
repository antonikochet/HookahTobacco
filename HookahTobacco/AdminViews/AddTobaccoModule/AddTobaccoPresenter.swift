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
    func receivedSuccessAddition() {
        view.hideLoading()
        view.showSuccessViewAlert(true)
    }
    
    func receivedSuccessEditing(with changedData: Tobacco) {
        view.hideLoading()
        view.showSuccessViewAlert(false)
        router.dismissView(with: changedData)
    }
    
    func receivedError(with code: Int, and message: String) {
        view.hideLoading()
        view.showAlertError(with: "Code - \(code). \(message)")
    }
    
    func showNameManufacturersForSelect(_ names: [String]) {
        manufacturerSelectItems = names
        manufacturerSelectItems.insert("-", at: 0)
    }
    
    func initialDataForPresentation(_ tobacco: AddTobaccoEntity.Tobacco, isEditing: Bool) {
        let tastes = tobacco.tastes.joined(separator: ", ")
        let textButton = isEditing ? "Изменить табак" : "Добавить табак"
        let viewModel = AddTobaccoEntity.ViewModel(
                            name: tobacco.name,
                            tastes: tastes,
                            description: tobacco.description,
                            textButton: textButton)
        view.setupContent(viewModel)
}
    
    func initialSelectedManufacturer(_ name: String?) {
        if let name = name,
           let index = manufacturerSelectItems.firstIndex(of: name) {
            view.setupSelectedManufacturer(index)
        } else {
            view.setupSelectedManufacturer(0)
        }
    }
    
    func initialMainImage(_ image: Data?) {
        let textButton = (image != nil
                          ? "Изменить изображение"
                          : "Добавить изображение")
        view.setupMainImage(image, textButton: textButton)
    }
}

extension AddTobaccoPresenter: AddTobaccoViewOutputProtocol {
    func pressedButtonAdded(with data: AddTobaccoEntity.EnteredData) {
        guard let name = data.name, !name.isEmpty else {
            view.showAlertError(with: "Название табака не введено, поле является обязательным!")
            return
        }
        guard let tastes = data.tastes, !tastes.isEmpty else {
            view.showAlertError(with: "Вкусы табака отсутсвуют, поле является обязательным!")
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
        view.showLoading()
        interactor.sendNewTobaccoToServer(tobaccoInteractor)
    }
    
    func didSelectedManufacturer(by index: Int) {
        guard !manufacturerSelectItems.isEmpty else { return }
        interactor.didSelectedManufacturer(manufacturerSelectItems[index])
    }
    
    func didSelectMainImage(with imageURL: URL) {
        interactor.didSelectMainImage(with: imageURL)
    }
    
    var numberOfRows: Int {
        manufacturerSelectItems.count
    }
    
    func receiveRow(by index: Int) -> String {
        manufacturerSelectItems[index]
    }
    
    func receiveIndexRow(for title: String) -> Int {
        guard let index = manufacturerSelectItems.firstIndex(of: title) else { return 0 }
        return index
    }
    
    func viewDidLoad() {
        interactor.receiveStartingDataView()
    }
}

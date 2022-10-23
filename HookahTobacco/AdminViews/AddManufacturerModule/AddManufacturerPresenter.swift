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
    
    private var viewModel: AddManufacturerEntity.ViewModel?
    private var isImage: Bool = false
}

extension AddManufacturerPresenter: AddManufacturerInteractorOutputProtocol {
    func receivedSuccessAddition() {
        view.showSuccessViewAlert(true)
    }
    
    func receivedSuccessEditing(with changedData: Manufacturer) {
        view.showSuccessViewAlert(false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.router.dismissView(with: changedData)
        }
    }
    
    func receivedError(with code: Int, and message: String) {
        view.showAlertError(with: "Code - \(code). \(message)")
    }
    
    func initialDataForPresentation(_ manufacturer: AddManufacturerEntity.Manufacturer, isEditing: Bool) {
        let viewModel = AddManufacturerEntity.ViewModel(
                            name: manufacturer.name,
                            country: manufacturer.country,
                            description: manufacturer.description ?? "",
                            textButton: isEditing ? "Изменить производителя" : "Добавить производителя")
        view.setupContent(viewModel)
    }
    
    func initialImage(_ image: Data?) {
        if let image = image {
            view.setupImageManufacturer(image, textButton: "Изменить изображение")
            isImage = true
        } else {
            view.setupImageManufacturer(nil, textButton: "Добавить изображение")
            isImage = false
        }
    }
}

extension AddManufacturerPresenter: AddManufacturerViewOutputProtocol {
    func pressedAddButton(with enteredData: AddManufacturerEntity.EnterData) {
        guard let name = enteredData.name, !name.isEmpty else {
            view.showAlertError(with: "Название производства не введено, поле является обязательным!")
            return
        }
        guard let country = enteredData.country, !country.isEmpty else {
            view.showAlertError(with: "Страна произовдителя не введена, поле является обязательным!")
            return
        }
        guard isImage else {
            view.showAlertError(with: "Не выбрано изображение")
            return
        }
        
        let data = AddManufacturerEntity.Manufacturer(name: name,
                                country: country,
                                description: enteredData.description)
        
        interactor.didEnterDataManufacturer(data)
    }
    
    func selectedImage(with urlFile: URL) {
        interactor.didSelectImage(with: urlFile)
        isImage = true
    }
    
    func viewDidLoad() {
        interactor.receiveStartingDataView()
    }
}

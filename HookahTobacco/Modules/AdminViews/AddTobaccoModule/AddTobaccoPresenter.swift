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
    // MARK: - Public properties
    weak var view: AddTobaccoViewInputProtocol!
    var interactor: AddTobaccoInteractorInputProtocol!
    var router: AddTobaccoRouterProtocol!

    // MARK: - Private properties
    private var manufacturerSelectItems: [String] = ["-"]
    private var tasteViewModels: [TasteCollectionCellViewModel] = []
}

// MARK: - InteractorOutputProtocol implementation
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
        let textButton = isEditing ? "Изменить табак" : "Добавить табак"
        let viewModel = AddTobaccoEntity.ViewModel(
                            name: tobacco.name,
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

    func receivedTastesForEditing(_ tastes: SelectedTastes) {
        router.showAddTastesView(tastes, outputModule: self)
    }
    
    func initialTastes(_ tastes: [Taste]) {
        tasteViewModels = tastes.map { TasteCollectionCellViewModel(taste: $0.taste) }
        view.setupTastes()
    }
}

// MARK: - AddTobaccoViewOutputProtocol implementation
extension AddTobaccoPresenter: AddTobaccoViewOutputProtocol {
    func pressedButtonAdded(with data: AddTobaccoEntity.EnteredData) {
        guard let name = data.name, !name.isEmpty else {
            view.showAlertError(with: "Название табака не введено, поле является обязательным!")
            return
        }
        
        let description = data.description ?? ""
        let tobaccoInteractor = AddTobaccoEntity.Tobacco(name: name,
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
    
    var tasteNumberOfRows: Int {
        tasteViewModels.count
    }
    
    func getTasteViewModel(by index: Int) -> TasteCollectionCellViewModel {
        tasteViewModels[index]
    }
    
    func didTouchSelectedTastes() {
        interactor.receiveTastesForEditing()
    }
}

// MARK: - AddTastesOutputModule implementation
extension AddTobaccoPresenter: AddTastesOutputModule {
    func sendSelectedTastes(_ tastes: [Taste]) {
        interactor.receivedNewSelectedTastes(tastes)
    }
}

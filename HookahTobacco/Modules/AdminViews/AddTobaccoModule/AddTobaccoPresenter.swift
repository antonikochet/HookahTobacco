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
    private var tobaccoLinesSelectItems: [String] = ["Отсутствует"]
}

// MARK: - InteractorOutputProtocol implementation
extension AddTobaccoPresenter: AddTobaccoInteractorOutputProtocol {
    func receivedSuccessAddition() {
        view.hideLoading()
        tasteViewModels = []
        router.showSuccess(delay: 2.0)
        view.clearView()
    }

    func receivedSuccessEditing(with changedData: Tobacco) {
        view.hideLoading()
        router.showSuccess(delay: 2.0)
        router.dismissView(with: changedData)
    }

    func receivedError(with message: String) {
        view.hideLoading()
        router.showError(with: message)
    }

    func showNameManufacturersForSelect(_ names: [String]) {
        manufacturerSelectItems = names
        manufacturerSelectItems.insert("-", at: 0)
    }

    func showNameTobaccoLinesForSelect(_ names: [String]) {
        tobaccoLinesSelectItems = names
        if names.isEmpty {
            tobaccoLinesSelectItems.insert("Отсутствует", at: 0)
            initialSelectedTobaccoLine("Отсутствует")
        } else {
            tobaccoLinesSelectItems.insert("-", at: 0)
            initialSelectedTobaccoLine("-")
        }
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

    func initialSelectedTobaccoLine(_ name: String?) {
        if let name = name,
           let index = tobaccoLinesSelectItems.firstIndex(of: name) {
            view.setupSelectedTobaccoLine(index)
        } else {
            view.setupSelectedTobaccoLine(0)
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
        tasteViewModels = tastes.map { TasteCollectionCellViewModel(label: $0.taste) }
        view.setupTastes()
    }
}

// MARK: - AddTobaccoViewOutputProtocol implementation
extension AddTobaccoPresenter: AddTobaccoViewOutputProtocol {
    func pressedButtonAdded(with data: AddTobaccoEntity.EnteredData) {
        guard let name = data.name, !name.isEmpty else {
            router.showError(with: "Название табака не введено, поле является обязательным!")
            return
        }

        let description = data.description ?? ""
        let tobaccoInteractor = AddTobaccoEntity.Tobacco(name: name,
                                                         description: description)
        view.showLoading()
        interactor.sendNewTobaccoToServer(tobaccoInteractor)
    }

    func didSelected(by index: Int, type: AddPicketType) {
        switch type {
        case .manufacturer:
            guard !manufacturerSelectItems.isEmpty else { return }
            interactor.didSelectedManufacturer(manufacturerSelectItems[index])
        case .tobaccoLine:
            guard !tobaccoLinesSelectItems.isEmpty else { return }
            interactor.didSelectedTobaccoLine(tobaccoLinesSelectItems[index])
        }
    }

    func didSelectMainImage(with imageURL: URL) {
        interactor.didSelectMainImage(with: imageURL)
    }

    func numbreOfRows(type: AddPicketType) -> Int {
        switch type {
        case .manufacturer:
            return manufacturerSelectItems.count
        case .tobaccoLine:
            return tobaccoLinesSelectItems.count
        }
    }

    func receiveRow(by index: Int, type: AddPicketType) -> String {
        switch type {
        case .manufacturer:
            return manufacturerSelectItems[index]
        case .tobaccoLine:
            return tobaccoLinesSelectItems[index]
        }
    }

    func receiveIndexRow(for title: String, type: AddPicketType) -> Int {
        switch type {
        case .manufacturer:
            guard let index = manufacturerSelectItems.firstIndex(of: title) else { return 0 }
            return index
        case .tobaccoLine:
            guard let index = tobaccoLinesSelectItems.firstIndex(of: title) else { return 0 }
            return index
        }
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

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
    // MARK: - Public properties
    weak var view: AddManufacturerViewInputProtocol!
    var interactor: AddManufacturerInteractorInputProtocol!
    var router: AddManufacturerRouterProtocol!

    // MARK: - Private properties
    private var tobaccoLinesViewModels: [TasteCollectionCellViewModel] = []
    private var countries: [String] = []
    private var isImage: Bool = false

    // MARK: - Private methods
    private func createTobaccoLineViewModel(_ tobaccoLine: TobaccoLine?,
                                            selectedTobaccoTypeIndex: Int,
                                            selectedTobaccoLeafIndexs: [Int]
    ) -> AddTobaccoLineViewViewModelProtocol {
        if let tobaccoLine = tobaccoLine {
            return AddManufacturerEntity.TobaccoLineModel(
                name: tobaccoLine.name,
                paramTobacco: AddManufacturerEntity.ParamTobaccoModel(
                    packetingFormats: tobaccoLine.packetingFormat
                        .map { String($0) }
                        .joined(separator: ", "),
                    tobaccoTypes: TobaccoType.allCases.map { $0.name },
                    selectedTobaccoTypeIndex: selectedTobaccoTypeIndex,
                    isBaseLine: tobaccoLine.isBase,
                    tobaccoLeafTypes: VarietyTobaccoLeaf.allCases.map { $0.name },
                    selectedTobaccoLeafTypeIndex: selectedTobaccoLeafIndexs),
                description: tobaccoLine.description
            )
        } else {
            return AddManufacturerEntity.TobaccoLineModel(
                name: "",
                paramTobacco: AddManufacturerEntity.ParamTobaccoModel(
                    packetingFormats: "",
                    tobaccoTypes: TobaccoType.allCases.map { $0.name },
                    selectedTobaccoTypeIndex: selectedTobaccoTypeIndex,
                    isBaseLine: false,
                    tobaccoLeafTypes: VarietyTobaccoLeaf.allCases.map { $0.name },
                    selectedTobaccoLeafTypeIndex: selectedTobaccoLeafIndexs
                ),
                description: ""
            )
        }
    }
}

// MARK: - InteractorOutputProtocol implementation
extension AddManufacturerPresenter: AddManufacturerInteractorOutputProtocol {
    func receivedSuccessAddition() {
        view.hideLoading()
        tobaccoLinesViewModels = []
        view.clearView()
        showCountryForSelect(nil)
        router.showSuccess(delay: 2.0)
    }

    func receivedSuccessEditing(with changedData: Manufacturer) {
        view.hideLoading()
        router.showSuccess(delay: 2.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.router.dismissView(with: changedData)
        }
    }

    func receivedError(with message: String) {
        view.hideLoading()
        router.showError(with: message)
    }

    func initialDataForPresentation(_ manufacturer: AddManufacturerEntity.Manufacturer, isEditing: Bool) {
        let viewModel = AddManufacturerEntity.ViewModel(
                            name: manufacturer.name,
                            description: manufacturer.description ?? "",
                            textButton: isEditing ? "Изменить производителя" : "Добавить производителя",
                            link: manufacturer.link ?? "",
                            isEnabledAddTobaccoLine: isEditing)
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

    func initialTobaccoLines(_ lines: [TobaccoLine]) {
        tobaccoLinesViewModels = lines.map { TasteCollectionCellViewModel(label: $0.isBase ? "Базовая линейка" : $0.name) }
        view.setupTobaccoLines()
    }

    func changeTobaccoLine(for id: Int, _ line: TobaccoLine) {
        router.showAddTobaccoLineView(for: id, editing: line)
    }

    func initialCounties(_ countries: [Country]) {
        self.countries = countries.map { $0.name }
        if self.countries.isEmpty {
            self.countries.insert("Отсутствует", at: 0)
            showCountryForSelect("Отсутствует")
        } else {
            self.countries.insert("-", at: 0)
            showCountryForSelect("-")
        }
    }

    func showCountryForSelect(_ country: String?) {
        if let country,
           let index = countries.firstIndex(of: country) {
            view.setupSelectedCountry(index)
        } else {
            view.setupSelectedCountry(0)
        }
    }
}

// MARK: - ViewOutputProtocol implementation
extension AddManufacturerPresenter: AddManufacturerViewOutputProtocol {
    func pressedAddButton(with enteredData: AddManufacturerEntity.EnterData) {
        guard let name = enteredData.name, !name.isEmpty else {
            router.showError(with: "Название производства не введено, поле является обязательным!")
            return
        }
        guard isImage else {
            router.showError(with: "Не выбрано изображение")
            return
        }

        let data = AddManufacturerEntity.Manufacturer(
                        name: name,
                        description: enteredData.description,
                        link: enteredData.link)

        view.showLoading()
        interactor.didEnterDataManufacturer(data)
    }

    func selectedImage(with urlFile: URL) {
        interactor.didSelectImage(with: urlFile)
        isImage = true
    }

    func viewDidLoad() {
        interactor.receiveStartingDataView()
    }

    func getTobaccoLineViewModel(at index: Int) -> TasteCollectionCellViewModel {
        tobaccoLinesViewModels[index]
    }

    var tobaccoLineNumberOfRows: Int {
        tobaccoLinesViewModels.count
    }

    func returnTobaccoLine(_ viewModel: TobaccoLineViewModelProtocol) {
        var name = viewModel.name
        if viewModel.isBase {
            name = "Base"
        } else if name.isEmpty {
            router.showError(with: "Имя линейки табака не введено")
            return
        }
        guard !viewModel.packetingFormats.isEmpty else {
            router.showError(with: "Не введен вес упаковок в линейке")
            return
        }
        guard viewModel.selectedTobaccoTypeIndex != -1 else {
            router.showError(with: "Не выбран тип табака")
            return
        }
        guard !viewModel.description.isEmpty else {
            router.showError(with: "Описание линейки табака не введено")
    func pressedEditingTobaccoLine(at index: Int) {
        interactor.receiveEditingTobaccoLine(at: index)
    }

    func pressedAddTobaccoLine() {
        guard let id = interactor.manufacturerId else {
            router.showError(with: "Для добавления линеек табака нужно добавить производителя на сервер")
            return
        }
        router.showAddTobaccoLineView(for: id, editing: nil)
    }

    func pressedAddCountry() {
        router.showAddCountryView()
    }

    func numberOfRowsCountries() -> Int {
        return countries.count
    }

    func receiveRowCountry(by index: Int) -> String {
        guard index < countries.count else {
            return "Отсутствует"
        }
        return countries[index]
    }

    func receiveIndexRowCountry(for title: String) -> Int {
        countries.firstIndex(of: title) ?? 0
    }

    func didSelectedCounty(by index: Int) {
        interactor.didSelectCountry(at: index)
    }
}

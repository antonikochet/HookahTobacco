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
    private var viewModel: AddManufacturerEntity.ViewModel?
    private var tobaccoLinesViewModels: [TasteCollectionCellViewModel] = []
    private var tobaccoLineViewModel: AddTobaccoLineViewViewModelProtocol?
    private var editingTobaccoLineIndex: Int?
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
        tobaccoLineViewModel = nil
        view.clearView()
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
                            country: manufacturer.country,
                            description: manufacturer.description ?? "",
                            textButton: isEditing ? "Изменить производителя" : "Добавить производителя",
                            link: manufacturer.link ?? "")
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
        tobaccoLinesViewModels = lines.map { TasteCollectionCellViewModel(label: $0.name) }
        view.setupTobaccoLines()
    }

    func initialTobaccoLine(_ line: TobaccoLine) {
        tobaccoLineViewModel = createTobaccoLineViewModel(
            line,
            selectedTobaccoTypeIndex: line.tobaccoType.rawValue,
            selectedTobaccoLeafIndexs: line.tobaccoLeafType?.map { $0.rawValue } ?? [])
        view.showTobaccoLineView()
    }
}

// MARK: - ViewOutputProtocol implementation
extension AddManufacturerPresenter: AddManufacturerViewOutputProtocol {
    func pressedAddButton(with enteredData: AddManufacturerEntity.EnterData) {
        guard let name = enteredData.name, !name.isEmpty else {
            router.showError(with: "Название производства не введено, поле является обязательным!")
            return
        }
        guard let country = enteredData.country, !country.isEmpty else {
            router.showError(with: "Страна произовдителя не введена, поле является обязательным!")
            return
        }
        guard isImage else {
            router.showError(with: "Не выбрано изображение")
            return
        }

        let data = AddManufacturerEntity.Manufacturer(
                        name: name,
                        country: country,
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

    func getTobaccoLineViewModel() -> AddTobaccoLineViewViewModelProtocol {
        tobaccoLineViewModel ?? createTobaccoLineViewModel(nil,
                                                           selectedTobaccoTypeIndex: -1,
                                                           selectedTobaccoLeafIndexs: [])
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
            return
        }
        if viewModel.selectedTobaccoTypeIndex == TobaccoType.tobacco.rawValue,
           viewModel.selectedTobaccoLeafTypeIndexs.isEmpty {
            router.showError(with: "Сорта табаков не выбраны для линейки")
            return
        }
        let intPF = viewModel.packetingFormats.replacingOccurrences(of: "\\s*",
                                                                    with: "",
                                                                    options: [.regularExpression])
                                                .split(separator: ",")
                                                .compactMap { Int($0) }
        let tobaccoLine = AddManufacturerEntity.TobaccoLine(
            name: name,
            packetingFormats: intPF,
            selectedTobaccoTypeIndex: viewModel.selectedTobaccoTypeIndex,
            description: viewModel.description,
            isBase: viewModel.isBase,
            selectedTobaccoLeafTypeIndexs: viewModel.selectedTobaccoLeafTypeIndexs
        )
        view.receivedResultAddTobaccoLine(isResult: true)
        interactor.didEnterTobaccoLine(tobaccoLine, index: editingTobaccoLineIndex)
        editingTobaccoLineIndex = nil
    }

    func pressedEditingTobaccoLine(at index: Int) {
        editingTobaccoLineIndex = index
        interactor.receiveEditingTobaccoLine(at: index)
    }

    func pressedCloseEditingTobaccoLine() {
        editingTobaccoLineIndex = nil
    }
}

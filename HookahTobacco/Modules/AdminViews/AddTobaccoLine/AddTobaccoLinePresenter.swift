//
//
//  AddTobaccoLinePresenter.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 04.08.2023.
//
//

import Foundation

class AddTobaccoLinePresenter {
    // MARK: - Public properties
    weak var view: AddTobaccoLineViewInputProtocol!
    var interactor: AddTobaccoLineInteractorInputProtocol!
    var router: AddTobaccoLineRouterProtocol!

    // MARK: - Private properties

    // MARK: - Private methods

}

// MARK: - InteractorOutputProtocol implementation
extension AddTobaccoLinePresenter: AddTobaccoLineInteractorOutputProtocol {
    func initialDataForPresentation(_ tobaccoLine: TobaccoLine?) {
        let viewModel: AddTobaccoLineEntity.EnterData
        if let tobaccoLine {
            viewModel = AddTobaccoLineEntity.EnterData(
                name: tobaccoLine.name,
                packetingFormats: tobaccoLine.packetingFormat
                    .map { String($0) }
                    .joined(separator: ", "),
                tobaccoTypes: TobaccoType.allCases.map { $0.name },
                selectedTobaccoTypeIndex: tobaccoLine.tobaccoType.rawValue,
                isBaseLine: tobaccoLine.isBase,
                tobaccoLeafTypes: VarietyTobaccoLeaf.allCases.map { $0.name },
                selectedTobaccoLeafTypeIndex: tobaccoLine.tobaccoLeafType?.map { $0.rawValue } ?? [],
                description: tobaccoLine.description
            )
        } else {
            viewModel = AddTobaccoLineEntity.EnterData(
                name: "",
                packetingFormats: "",
                tobaccoTypes: TobaccoType.allCases.map { $0.name },
                selectedTobaccoTypeIndex: -1,
                isBaseLine: false,
                tobaccoLeafTypes: VarietyTobaccoLeaf.allCases.map { $0.name },
                selectedTobaccoLeafTypeIndex: [],
                description: ""
            )
        }
        view?.setupView(viewModel)
    }

    func receivedError(with message: String) {
        view.hideLoading()
        router.showError(with: message)
    }

    func receivedSuccess(with tobaccoLine: TobaccoLine) {
        view.hideLoading()
        router.showSuccess(delay: 3.0) { [weak self] in
            self?.router.dismissView(with: tobaccoLine)
        }
    }
}

// MARK: - ViewOutputProtocol implementation
extension AddTobaccoLinePresenter: AddTobaccoLineViewOutputProtocol {
    func viewDidLoad() {
        interactor.receiveStartingDataView()
    }

    func pressedDoneButton(_ viewModel: AddTobaccoLineEntity.ViewModel) {
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
        let tobaccoLine = AddTobaccoLineEntity.TobaccoLine(
            name: name,
            packetingFormats: intPF,
            selectedTobaccoTypeIndex: viewModel.selectedTobaccoTypeIndex,
            description: viewModel.description,
            isBase: viewModel.isBase,
            selectedTobaccoLeafTypeIndexs: viewModel.selectedTobaccoLeafTypeIndexs
        )
        view.showLoading()
        interactor.didEnterData(tobaccoLine)
    }

    func pressedCloseButton() {
        router.dismissView()
    }
}

//
//
//  DetailTobaccoPresenter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 25.11.2022.
//
//

import Foundation

class DetailTobaccoPresenter {
    // MARK: - Public properties
    weak var view: DetailTobaccoViewInputProtocol!
    var interactor: DetailTobaccoInteractorInputProtocol!
    var router: DetailTobaccoRouterProtocol!

    // MARK: - Private properties
    private var tasteViewModels: [TasteCollectionCellViewModel] = []

    // MARK: - Private methods
    private func createTasteViewModel(_ taste: Taste) -> TasteCollectionCellViewModel {
        TasteCollectionCellViewModel(label: taste.taste)
    }

    private func createViewModel(_ tobacco: DetailTobaccoEntity.Tobacco) -> DetailTobaccoEntity.ViewModel {
        let description = !tobacco.description.isEmpty ? "Описание: \(tobacco.description)" : nil
        let packetingFormat = tobacco.line.packetingFormat.compactMap { "\($0) гр." }.joined(separator: ", ")
        let tobaccoLeafType = (tobacco.line.tobaccoType.rawValue == TobaccoType.tobacco.rawValue ?
                               tobacco.line.tobaccoLeafType?.map { $0.name }.joined(separator: ", ") :
                                nil)
        return DetailTobaccoEntity.ViewModel(
            image: tobacco.image,
            name: tobacco.name,
            nameManufacturer: tobacco.nameManufacturer,
            description: description,
            nameLine: tobacco.line.isBase ? nil : "Название линейки: \(tobacco.line.name)",
            packetingFormat: "Формат фасовки табака: \(packetingFormat)",
            tobaccoType: "Тип табака: \(tobacco.line.tobaccoType.name)",
            tobaccoLeafType: tobaccoLeafType != nil ? "Типы листа: \(tobaccoLeafType!)" : nil
        )
    }
}

// MARK: - InteractorOutputProtocol implementation
extension DetailTobaccoPresenter: DetailTobaccoInteractorOutputProtocol {
    func receivedError(with message: String) {
        router.showError(with: message)
    }

    func initialDataForPresentation(_ tobacco: DetailTobaccoEntity.Tobacco) {
        let viewModel = createViewModel(tobacco)
        tasteViewModels = tobacco.tastes.map { createTasteViewModel($0) }
        view.setupContent(viewModel)
        view.setupTasteView()
    }
}

// MARK: - ViewOutputProtocol implementation
extension DetailTobaccoPresenter: DetailTobaccoViewOutputProtocol {
    var tasteNumberOfRows: Int {
        tasteViewModels.count
    }

    func getTasteViewModel(at index: Int) -> TasteCollectionCellViewModel {
        tasteViewModels[index]
    }

    func viewDidLoad() {
        interactor.receiveStartingDataView()
    }
}

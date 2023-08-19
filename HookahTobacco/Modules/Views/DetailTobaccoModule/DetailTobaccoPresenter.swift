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

    private func createViewModel(_ tobacco: Tobacco) -> DetailTobaccoViewModel {
        let description = !tobacco.description.isEmpty ? .description + tobacco.description : nil
        let packetingFormat = tobacco.line.packetingFormat.compactMap { String($0) + .gram }
                                                          .joined(separator: ", ")
        let tobaccoLeafType = (tobacco.line.tobaccoType.rawValue == TobaccoType.tobacco.rawValue ?
                               tobacco.line.tobaccoLeafType?.map { $0.name }.joined(separator: ", ") :
                                nil)
        var info: [DescriptionStackViewItem] = []
        if !tobacco.line.isBase {
            info.append(DescriptionStackViewItem(name: .nameOfLine, description: tobacco.line.name))
        }
        info.append(DescriptionStackViewItem(name: .packagingFormat, description: packetingFormat))
        info.append(DescriptionStackViewItem(name: .tobaccoType, description: tobacco.line.tobaccoType.name))
        if let tobaccoLeafType {
            info.append(DescriptionStackViewItem(name: .tobaccoLeafType, description: tobaccoLeafType))
        }

        return DetailTobaccoViewModel(
            image: tobacco.image,
            name: tobacco.name,
            nameManufacturer: tobacco.nameManufacturer,
            description: description,
            info: info
        )
    }
}

// MARK: - InteractorOutputProtocol implementation
extension DetailTobaccoPresenter: DetailTobaccoInteractorOutputProtocol {
    func receivedError(_ error: HTError) {
        router.showError(with: error.message)
    }

    func initialDataForPresentation(_ tobacco: Tobacco) {
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

private extension String {
    static let description = "Описание: "
    static let gram = " гр."
    static let nameOfLine = "Название линейки"
    static let packagingFormat = "Формат фасовки табака"
    static let tobaccoType = "Тип табака"
    static let tobaccoLeafType = "Типы листа"
}

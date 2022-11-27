//
//
//  DetailInfoManufacturerPresenter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 31.10.2022.
//
//

import Foundation

class DetailInfoManufacturerPresenter {
    // MARK: - Public properties
    weak var view: DetailInfoManufacturerViewInputProtocol!
    var interactor: DetailInfoManufacturerInteractorInputProtocol!
    var router: DetailInfoManufacturerRouterProtocol!

    // MARK: - Private properties
    private var nameManufacturerTitle: String?
    private var linkToManufacturer: String?
    private var detailInfoManufacturerViewModel: DetailInfoManufacturerCellViewModelProtocol?
    private var tobaccoViewModels: [TobaccoListCellViewModel] = []

    // MARK: - Private methods
    private func createTobaccoViewModel(
        _ tobacco: DetailInfoManufacturerEntity.Tobacco
    ) -> TobaccoListCellViewModel {
        TobaccoListCellViewModel(
            name: tobacco.name,
            tasty: tobacco.tasty
                .map { $0.taste }
                .joined(separator: ", "),
            manufacturerName: "",
            image: tobacco.image
        )
    }
}

// MARK: - InteractorOutputProtocol implementation
extension DetailInfoManufacturerPresenter: DetailInfoManufacturerInteractorOutputProtocol {
    func initialDataForPresentation(_ manufacturer: Manufacturer) {
        detailInfoManufacturerViewModel = DetailInfoManufacturerEntity.CellViewModel(
            country: "Страна производителя: \(manufacturer.country)",
            description: manufacturer.description.isEmpty ? "" : "Описание: \n\(manufacturer.description)",
            iconImage: manufacturer.image
        )
        nameManufacturerTitle = manufacturer.name
        linkToManufacturer = manufacturer.link
        view.showData()
    }

    func receivedTobacco(with tobaccos: [DetailInfoManufacturerEntity.Tobacco]) {
        tobaccoViewModels = tobaccos.map {
            createTobaccoViewModel($0)
        }
        view.showData()
    }

    func receivedError(with message: String) {
        router.showError(with: message)
    }

    func receivedUpdate(for tobacco: DetailInfoManufacturerEntity.Tobacco, at index: Int) {
        let viewModel = createTobaccoViewModel(tobacco)
        tobaccoViewModels[index] = viewModel
        view.updateRow(at: index)
    }
}

// MARK: - ViewOutputProtocol implementation
extension DetailInfoManufacturerPresenter: DetailInfoManufacturerViewOutputProtocol {
    var nameManufacturer: String? {
        nameManufacturerTitle
    }

    var tobaccoNumberOfRows: Int {
        tobaccoViewModels.count
    }

    var detailViewModelCell: DetailInfoManufacturerCellViewModelProtocol? {
        detailInfoManufacturerViewModel
    }

    var linkToManufacturerWebside: String? {
        linkToManufacturer != nil && !linkToManufacturer!.isEmpty ? "Сайт производителя: \(linkToManufacturer!)" : nil
    }

    func tobaccoViewModelCell(at row: Int) -> TobaccoListCellViewModel {
        tobaccoViewModels[row]
    }

    func viewDidLoad() {
        interactor.receiveStartingDataView()
    }

    var isTobaccosEmpty: Bool {
        tobaccoViewModels.isEmpty
    }
}

//
//
//  DetailTobaccoInteractor.swift
//  HookahTobacco
//
//  Created by антон кочетков on 25.11.2022.
//
//

import Foundation

protocol DetailTobaccoInteractorInputProtocol: AnyObject {
    func receiveStartingDataView()
}

protocol DetailTobaccoInteractorOutputProtocol: AnyObject {
    func initialDataForPresentation(_ tobacco: DetailTobaccoEntity.Tobacco)
    func receivedError(with message: String)
}

class DetailTobaccoInteractor {
    // MARK: - Public properties
    weak var presenter: DetailTobaccoInteractorOutputProtocol!

    // MARK: - Dependency
    private let getDataManager: DataManagerProtocol

    // MARK: - Private properties
    private var tobacco: Tobacco

    // MARK: - Initializers
    init(_ tobacco: Tobacco,
         getDataManager: DataManagerProtocol) {
        self.tobacco = tobacco
        self.getDataManager = getDataManager
    }

    // MARK: - Private methods
    private func createDataForPresentation() -> DetailTobaccoEntity.Tobacco {
        DetailTobaccoEntity.Tobacco(name: tobacco.name,
                                    image: tobacco.image,
                                    tastes: tobacco.tastes,
                                    nameManufacturer: tobacco.nameManufacturer,
                                    description: tobacco.description)
    }
}

// MARK: - InputProtocol implementation 
extension DetailTobaccoInteractor: DetailTobaccoInteractorInputProtocol {
    func receiveStartingDataView() {
        presenter.initialDataForPresentation(createDataForPresentation())
    }
}

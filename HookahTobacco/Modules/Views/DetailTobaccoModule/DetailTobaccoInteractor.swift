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
    private var tastes: [Taste] = []

    // MARK: - Initializers
    init(_ tobacco: Tobacco,
         getDataManager: DataManagerProtocol) {
        self.tobacco = tobacco
        self.getDataManager = getDataManager
        receiveTastes()
    }

    // MARK: - Private methods
    private func receiveTastes() {
        getDataManager.receiveTastes(at: tobacco.taste) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let tastes):
                self.tastes = tastes
                DispatchQueue.main.async {
                    self.presenter.initialDataForPresentation(self.createDataForPresentation())
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter.receivedError(with: error.localizedDescription)
                }
            }
        }
    }

    private func createDataForPresentation() -> DetailTobaccoEntity.Tobacco {
        DetailTobaccoEntity.Tobacco(name: tobacco.name,
                                    image: tobacco.image,
                                    tastes: tastes,
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

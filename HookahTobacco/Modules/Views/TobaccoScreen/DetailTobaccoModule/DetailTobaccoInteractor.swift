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

protocol DetailTobaccoInteractorOutputProtocol: PresenterrProtocol {
    func initialDataForPresentation(_ tobacco: Tobacco)
}

class DetailTobaccoInteractor {
    // MARK: - Public properties
    weak var presenter: DetailTobaccoInteractorOutputProtocol!

    // MARK: - Dependency

    // MARK: - Private properties
    private var tobacco: Tobacco

    // MARK: - Initializers
    init(_ tobacco: Tobacco) {
        self.tobacco = tobacco
    }

    // MARK: - Private methods
}

// MARK: - InputProtocol implementation 
extension DetailTobaccoInteractor: DetailTobaccoInteractorInputProtocol {
    func receiveStartingDataView() {
        presenter.initialDataForPresentation(tobacco)
    }
}

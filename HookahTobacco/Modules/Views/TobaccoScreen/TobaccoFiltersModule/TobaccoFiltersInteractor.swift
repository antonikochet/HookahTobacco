//
//
//  TobaccoFiltersInteractor.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 29.08.2023.
//
//

import Foundation
import HookahTobaccoCore

protocol TobaccoFiltersInteractorInputProtocol: AnyObject {
    func receiveStartingData()
    func receiveBaseFilters()
    func updateFilters(_ sendFilter: TobaccoFilter)
}

protocol TobaccoFiltersInteractorOutputProtocol: PresenterrProtocol {
    func receivedFilters(_ filters: TobaccoFilter)
    func selectedFilters(_ selectedFilters: TobaccoFilter)
}

class TobaccoFiltersInteractor {
    // MARK: - Public properties
    weak var presenter: TobaccoFiltersInteractorOutputProtocol!

    // MARK: - Dependency
    private let tobaccoRepo: TobaccoRepoProtocol

    // MARK: - Private properties
    private var filters: TobaccoFilter?
    private var baseFilters: TobaccoFilter?

    // MARK: - Initializers
    init(filters: TobaccoFilter?,
         tobaccoRepo: TobaccoRepoProtocol) {
        self.filters = filters
        self.tobaccoRepo = tobaccoRepo
    }

    // MARK: - Private methods
    private func receiveTobaccoFilters() {
        tobaccoRepo.fetchTobaccoFilters { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(filters):
                self.baseFilters = filters
                self.presenter.receivedFilters(filters)
            case let .failure(error):
                self.presenter.receivedError(HTError.createError(error))
            }
        }
    }

    private func sendTobaccoFilters(_ filters: TobaccoFilter) {
        tobaccoRepo.updateTobaccoFilters(filters: filters) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(filters):
                self.presenter.receivedFilters(filters)
            case let .failure(error):
                self.presenter.receivedError(HTError.createError(error))
            }
        }
    }
}
// MARK: - InputProtocol implementation 
extension TobaccoFiltersInteractor: TobaccoFiltersInteractorInputProtocol {
    func receiveStartingData() {
        if let filters {
            sendTobaccoFilters(filters)
            presenter.selectedFilters(filters)
        } else {
            receiveTobaccoFilters()
        }
    }

    func receiveBaseFilters() {
        if let baseFilters {
            presenter.receivedFilters(baseFilters)
        } else {
            receiveTobaccoFilters()
        }
    }
    func updateFilters(_ sendFilter: TobaccoFilter) {
        sendTobaccoFilters(sendFilter)
    }
}

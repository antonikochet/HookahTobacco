//
//
//  TobaccoFiltersInteractor.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 29.08.2023.
//
//

import Foundation

protocol TobaccoFiltersInteractorInputProtocol: AnyObject {
    func receiveStartingData()
    func receiveBaseFilters()
    func updateFilters(_ sendFilter: TobaccoFilters)
}

protocol TobaccoFiltersInteractorOutputProtocol: PresenterrProtocol {
    func receivedFilters(_ filters: TobaccoFilters)
    func selectedFilters(_ selectedFilters: TobaccoFilters)
}

class TobaccoFiltersInteractor {
    // MARK: - Public properties
    weak var presenter: TobaccoFiltersInteractorOutputProtocol!

    // MARK: - Dependency
    private let dataNetworkingService: GetDataNetworkingServiceProtocol

    // MARK: - Private properties
    private var filters: TobaccoFilters?
    private var baseFilters: TobaccoFilters?

    // MARK: - Initializers
    init(filters: TobaccoFilters?,
         dataNetworkingService: GetDataNetworkingServiceProtocol) {
        self.filters = filters
        self.dataNetworkingService = dataNetworkingService
    }

    // MARK: - Private methods
    private func receiveTobaccoFilters() {
        dataNetworkingService.receiveTobaccoFilters { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(filters):
                self.baseFilters = filters
                self.presenter.receivedFilters(filters)
            case let .failure(error):
                self.presenter.receivedError(error)
            }
        }
    }

    private func sendTobaccoFilters(_ filters: TobaccoFilters) {
        dataNetworkingService.updateTobaccoFilters(filters: filters) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(filters):
                self.presenter.receivedFilters(filters)
            case let .failure(error):
                self.presenter.receivedError(error)
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
    func updateFilters(_ sendFilter: TobaccoFilters) {
        sendTobaccoFilters(sendFilter)
    }
}

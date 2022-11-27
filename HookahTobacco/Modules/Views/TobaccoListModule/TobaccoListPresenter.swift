//
//
//  TobaccoListPresenter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 26.10.2022.
//
//

import Foundation

class TobaccoListPresenter {
    // MARK: - Public properties
    weak var view: TobaccoListViewInputProtocol!
    var interactor: TobaccoListInteractorInputProtocol!
    var router: TobaccoListRouterProtocol!

    // MARK: - Private properties
    private var viewModels: [TobaccoListCellViewModel] = []

    // MARK: - Private methods
    private func createViewModel(_ data: TobaccoListEntity.Tobacco) -> TobaccoListCellViewModel {
        let taste = data.tasty
            .map { $0.taste }
            .joined(separator: ", ")
        return TobaccoListCellViewModel(
            name: data.name,
            tasty: taste,
            manufacturerName: data.nameManufacturer,
            image: data.image
        )
    }
}

// MARK: - InteractorOutputProtocol implementation
extension TobaccoListPresenter: TobaccoListInteractorOutputProtocol {
    func receivedSuccess(_ data: [TobaccoListEntity.Tobacco]) {
        viewModels = data.map { createViewModel($0) }
        view.showData()
    }

    func receivedError(with message: String) {
        router.showError(with: message)
    }

    func receivedUpdate(for data: TobaccoListEntity.Tobacco, at index: Int) {
        let viewModel = createViewModel(data)
        viewModels[index] = viewModel
        view.updateRow(at: index)
    }

    func receivedDataForShowDetail(_ tobacco: Tobacco) {
        router.showDetail(for: tobacco)
    }

    func receivedDataForEditing(_ tobacco: Tobacco) {
        router.showAddTobacco(tobacco, delegate: self)
    }
}

// MARK: - ViewOutputProtocol implementation
extension TobaccoListPresenter: TobaccoListViewOutputProtocol {
    var numberOfRows: Int {
        viewModels.count
    }

    func cellViewModel(at index: Int) -> TobaccoListCellViewModel {
        return viewModels[index]
    }

    func viewDidLoad() {
        interactor.startReceiveData()
    }

    func didTouchForElement(by index: Int) {
        interactor.receiveDataForShowDetail(by: index)
    }

    func didStartingRefreshView() {
        interactor.updateData()
    }
}

// MARK: - OutputModule implementation
extension TobaccoListPresenter: AddTobaccoOutputModule {
    func sendChangedTobacco(_ tobacco: Tobacco) {
        interactor.receivedDataFromOutside(tobacco)
    }
}

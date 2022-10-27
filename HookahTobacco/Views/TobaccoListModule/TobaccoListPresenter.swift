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
    weak var view: TobaccoListViewInputProtocol!
    var interactor: TobaccoListInteractorInputProtocol!
    var router: TobaccoListRouterProtocol!
    
    private var viewModels: [TobaccoListCellViewModel] = []
    
    private func createViewModel(_ data: Tobacco) -> TobaccoListCellViewModel {
        let taste = data.taste.joined(separator: ", ")
        return TobaccoListCellViewModel(name: data.name,
                                        tasty: taste,
                                        manufacturerName: data.nameManufacturer,
                                        image: data.image)
    }
}

extension TobaccoListPresenter: TobaccoListInteractorOutputProtocol {
    func receivedSuccess(_ data: [Tobacco]) {
        viewModels = data.map { createViewModel($0) }
        view.showData()
    }
    
    func receivedError(with code: Int, and message: String) {
        view.showErrorAlert(with: "Code - \(code). \(message)")
    }
    
    func receivedError(with message: String) {
        view.showErrorAlert(with: message)
    }
    
    func receivedUpdate(for data: Tobacco, at index: Int) {
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
}

extension TobaccoListPresenter: AddTobaccoOutputModule {
    func sendChangedTobacco(_ tobacco: Tobacco) {
        interactor.receivedDataFromOutside(tobacco)
    }
}

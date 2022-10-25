//
//
//  ManufacturerListPresenter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 13.10.2022.
//
//

import Foundation

class ManufacturerListPresenter {
    weak var view: ManufacturerListViewInputProtocol!
    var interactor: ManufacturerListInteractorInputProtocol!
    var router: ManufacturerListRouterProtocol!
    
    private var viewModels: [ManufacturerListEntity.ViewModel] = []
    
    private func createViewModel(for manufacturer: Manufacturer) -> ManufacturerListEntity.ViewModel {
        return ManufacturerListEntity.ViewModel(name: manufacturer.name,
                                                country: manufacturer.country,
                                                image: manufacturer.image)
    }
}

extension ManufacturerListPresenter: ManufacturerListInteractorOutputProtocol {
    func receivedManufacturersSuccess(with data: [Manufacturer]) {
        viewModels = data.map { createViewModel(for: $0) }
        view.showData()
    }
    
    func receivedError(with message: String) {
        view.showError(with: message)
    }
    
    func receivedUpdate(for manufacturer: Manufacturer, at index: Int) {
        let newViewModel = createViewModel(for: manufacturer)
        viewModels[index] = newViewModel
        view.showRow(index)
    }
    
    func receivedDataForShowDetail(_ manudacturer: Manufacturer) {
        router.showDetail(for: manudacturer)
    }
    
    func receivedDataForEditing(_ manufacturer: Manufacturer) {
        router.showAddManufacturer(manufacturer, delegate: self)
    }
}

extension ManufacturerListPresenter: ManufacturerListViewOutputProtocol {
    var numberOfRows: Int {
        viewModels.count
    }
    
    func getViewModel(by row: Int) -> ManufacturerListEntity.ViewModel {
        viewModels[row]
    }
    
    func viewDidLoad() {
        interactor.startReceiveData()
    }
    
    func didTouchForElement(by row: Int) {
        interactor.receiveDataForShowDetail(by: row)
    }
}

extension ManufacturerListPresenter: AddManufacturerOutputModule {
    func sendChangedManufacturer(_ manufacture: Manufacturer) {
        interactor.receivedDataFromOutside(manufacture)
    }
}

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
}

extension ManufacturerListPresenter: ManufacturerListInteractorOutputProtocol {
    func receivedManufacturersSuccess(with data: [Manufacturer]) {
        viewModels = data.map {
            ManufacturerListEntity.ViewModel(name: $0.name,
                                             country: $0.country,
                                             image: nil)
        }
        view.showData()
    }
    
    func receivedError(with message: String) {
        view.showError(with: message)
    }
    
    func receivedImage(for manufacturer: Manufacturer, with data: Data) {
        guard let index = viewModels.firstIndex(where: { $0.name == manufacturer.name }) else { return }
        let viewModel = viewModels[index]
        let newViewModel = ManufacturerListEntity.ViewModel(name: viewModel.name,
                                                            country: viewModel.country,
                                                            image: data)
        viewModels[index] = newViewModel
        view.showImage(by: index)
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

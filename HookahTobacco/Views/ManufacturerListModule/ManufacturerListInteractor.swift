//
//
//  ManufacturerListInteractor.swift
//  HookahTobacco
//
//  Created by антон кочетков on 13.10.2022.
//
//

import Foundation
import SwiftUI

protocol ManufacturerListInteractorInputProtocol: AnyObject {
    func startReceiveData()
    func receiveDataForShowDetail(by index: Int)
    func receivedDataFromOutside(_ data: Manufacturer)
}

protocol ManufacturerListInteractorOutputProtocol: AnyObject {
    func receivedManufacturersSuccess(with data: [Manufacturer])
    func receivedError(with message: String)
    func receivedImage(for manufacturer: Manufacturer, with data: Data)
    func receivedDataForShowDetail(_ manudacturer: Manufacturer)
    func receivedDataForEditing(_ manufacturer: Manufacturer)
}

class ManufacturerListInteractor {
    weak var presenter: ManufacturerListInteractorOutputProtocol!
    
    private var manufacturers: [Manufacturer] = [] {
        didSet {
            presenter.receivedManufacturersSuccess(with: manufacturers)
        }
    }
    private var isAdminMode: Bool
    
    private var getDataManager: GetDataBaseNetworkingProtocol
    private var getImageManager: GetImageDataBaseProtocol
    
    init(_ isAdminMode: Bool,
         getDataManager: GetDataBaseNetworkingProtocol,
         getImageManager: GetImageDataBaseProtocol) {
        self.isAdminMode = isAdminMode
        self.getDataManager = getDataManager
        self.getImageManager = getImageManager
    }
    
    private func receiveManufacturers() {
        getDataManager.getManufacturers { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                    case .success(let data):
                        self.manufacturers = data
                    case .failure(let error):
                        self.presenter.receivedError(with: error.localizedDescription)
                }
                for i in 0..<self.manufacturers.count {
                    self.receiveImageManufacturer(by: i)
                }
            }
        }
    }
    
    private func receiveImageManufacturer(by index: Int) {
        guard index < manufacturers.count else { return }
        let manufacturer = manufacturers[index]
        guard let nameImage = manufacturer.image, !nameImage.isEmpty else { return }
        getImageManager.getImage(for: .manufacturerImage(name: nameImage)) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                    case .success(let data):
                        self.presenter.receivedImage(for: manufacturer, with: data)
                        break
                    case .failure(let error):
                        self.presenter.receivedError(with: error.localizedDescription)
                }
            }
        }
    }
}

extension ManufacturerListInteractor: ManufacturerListInteractorInputProtocol {
    func startReceiveData() {
        receiveManufacturers()
    }
    
    func receiveDataForShowDetail(by index: Int) {
        guard index < manufacturers.count else { return }
        if isAdminMode {
            presenter.receivedDataForEditing(manufacturers[index])
        } else {
            presenter.receivedDataForShowDetail(manufacturers[index])
        }
    }
    
    func receivedDataFromOutside(_ data: Manufacturer) {
        guard let index = manufacturers.firstIndex(where: { $0.uid == data.uid }) else { return }
        manufacturers[index] = data
    }
}

//
//
//  ManufacturerListInteractor.swift
//  HookahTobacco
//
//  Created by антон кочетков on 13.10.2022.
//
//

import Foundation

protocol ManufacturerListInteractorInputProtocol: AnyObject {
    func startReceiveData()
    func receiveDataForShowDetail(by index: Int)
    func receivedDataFromOutside(_ data: Manufacturer)
    func updateData()
}

protocol ManufacturerListInteractorOutputProtocol: AnyObject {
    func receivedManufacturersSuccess(with data: [Manufacturer])
    func receivedError(with message: String)
    func receivedUpdate(for manufacturer: Manufacturer, at index: Int)
    func receivedDataForShowDetail(_ manudacturer: Manufacturer)
    func receivedDataForEditing(_ manufacturer: Manufacturer)
}

class ManufacturerListInteractor {
    // MARK: - Public properties
    weak var presenter: ManufacturerListInteractorOutputProtocol!
    
    // MARK: - Dependency
    private var getDataManager: GetDataBaseNetworkingProtocol
    private var getImageManager: GetImageDataBaseProtocol
    
    // MARK: - Private properties
    private var manufacturers: [Manufacturer] = []
    private var isAdminMode: Bool
    
    // MARK: - Initializers
    init(_ isAdminMode: Bool,
         getDataManager: GetDataBaseNetworkingProtocol,
         getImageManager: GetImageDataBaseProtocol) {
        self.isAdminMode = isAdminMode
        self.getDataManager = getDataManager
        self.getImageManager = getImageManager
    }
    
    // MARK: - Private methods
    private func receiveManufacturers() {
        getDataManager.getManufacturers { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                    case .success(let data):
                        self.manufacturers = data
                        self.presenter.receivedManufacturersSuccess(with: data)
                    case .failure(let error):
                        self.presenter.receivedError(with: error.localizedDescription)
                }
                for (i, m) in self.manufacturers.enumerated() {
                    self.receiveImage(for: m, at: i)
                }
            }
        }
    }
    
    private func receiveImage(for manufacturer: Manufacturer, at index: Int) {
        let imageName = manufacturer.nameImage
        guard !imageName.isEmpty else { return }
        getImageManager.getImage(for: .manufacturerImage(name: imageName)) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                    case .success(let data):
                        var mutableManufacturer = manufacturer
                        mutableManufacturer.image = data
                        self.manufacturers[index] = mutableManufacturer
                        self.presenter.receivedUpdate(for: mutableManufacturer, at: index)
                    case .failure(let error):
                        self.presenter.receivedError(with: error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - InputProtocol implementation
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
        presenter.receivedUpdate(for: data, at: index)
    }
    
    func updateData() {
        receiveManufacturers()
    }
}

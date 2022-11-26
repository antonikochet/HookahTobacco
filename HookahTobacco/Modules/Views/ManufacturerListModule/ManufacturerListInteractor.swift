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
    private var getDataManager: DataManagerProtocol
    private var getImageManager: ImageManagerProtocol
    private var updateDataManager: UpdateDataManagerObserverProtocol

    // MARK: - Private properties
    private var manufacturers: [Manufacturer] = []
    private var isAdminMode: Bool

    // MARK: - Initializers
    init(_ isAdminMode: Bool,
         getDataManager: DataManagerProtocol,
         getImageManager: ImageManagerProtocol,
         updateDataManager: UpdateDataManagerObserverProtocol
    ) {
        self.isAdminMode = isAdminMode
        self.getDataManager = getDataManager
        self.getImageManager = getImageManager
        self.updateDataManager = updateDataManager
        self.updateDataManager.subscribe(to: Manufacturer.self, subscriber: self)
    }

    deinit {
        updateDataManager.unsubscribe(to: Manufacturer.self, subscriber: self)
    }

    // MARK: - Private methods
    private func receiveManufacturers() {
        getDataManager.receiveData(typeData: Manufacturer.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.manufacturers = data
                self.presenter.receivedManufacturersSuccess(with: data)
            case .failure(let error):
                self.presenter.receivedError(with: error.localizedDescription)
            }
            for (index, manufacturer) in self.manufacturers.enumerated() {
                self.receiveImage(for: manufacturer, at: index)
            }
        }
    }

    private func receiveImage(for manufacturer: Manufacturer, at index: Int) {
        let imageName = manufacturer.nameImage
        guard !imageName.isEmpty else { return }
        getImageManager.getImage(for: NamedImageManager.manufacturerImage(nameImage: imageName)) { [weak self] result in
            guard let self = self else { return }
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

// MARK: - DataManagerSubscriberProtocol implementation
extension ManufacturerListInteractor: DataManagerSubscriberProtocol {
    func notify<T>(for type: T.Type, newState: NewStateType<[T]>) {
        switch newState {
        case .update(let data):
            if let newManufacturers = data as? [Manufacturer] {
                manufacturers = newManufacturers
                presenter.receivedManufacturersSuccess(with: newManufacturers)
                newManufacturers.enumerated().forEach { receiveImage(for: $1, at: $0)
                }
            }
        case .error(let error):
            presenter.receivedError(with: error.localizedDescription)
        }
    }
}

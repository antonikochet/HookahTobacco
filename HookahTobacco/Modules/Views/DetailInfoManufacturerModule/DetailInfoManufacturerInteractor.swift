//
//
//  DetailInfoManufacturerInteractor.swift
//  HookahTobacco
//
//  Created by антон кочетков on 31.10.2022.
//
//

import Foundation

protocol DetailInfoManufacturerInteractorInputProtocol: AnyObject {
    func receiveStartingDataView()
    
}

protocol DetailInfoManufacturerInteractorOutputProtocol: AnyObject {
    func initialDataForPresentation(_ manufacturer: Manufacturer)
    func receivedTobacco(with tobaccos: [Tobacco])
    func receivedError(with code: Int, and message: String)
    func receivedError(with message: String)
    func receivedUpdate(for tobacco: Tobacco, at index: Int)
}

class DetailInfoManufacturerInteractor {
    // MARK: - Public properties
    weak var presenter: DetailInfoManufacturerInteractorOutputProtocol!
    
    // MARK: - Dependency
    private var getDataManager: GetDataBaseNetworkingProtocol
    private var getImageManager: GetImageDataBaseProtocol
    
    // MARK: - Private properties
    private var manufacturer: Manufacturer
    private var tobaccos: [Tobacco] = []
    
    // MARK: - Initializers
    init(_ manufacturer: Manufacturer,
         getDataManager: GetDataBaseNetworkingProtocol,
         getImageManager: GetImageDataBaseProtocol) {
        self.manufacturer = manufacturer
        self.getDataManager = getDataManager
        self.getImageManager = getImageManager
        receiveTobacco()
    }
    
    // MARK: - Private methods
    private func receiveTobacco() {
        getDataManager.getTobaccos(for: manufacturer) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let tobaccos):
                    self.tobaccos = tobaccos
                    self.presenter.receivedTobacco(with: tobaccos)
                    self.receiveImageTobaccos(tobaccos)
                case .failure(let error):
                    let err = error as NSError
                    self.presenter.receivedError(with: err.code, and: err.localizedDescription)
            }
        }
    }
    
    private func receiveImageTobaccos(_ tobaccos: [Tobacco]) {
        tobaccos.enumerated().forEach { index, tobacco in
            let named = NamedFireStorage.tobaccoImage(manufacturer: tobacco.nameManufacturer,
                                                      uid: tobacco.uid!,
                                                      type: .main)
            getImageManager.getImage(for: named) { [weak self] result in
                guard let self = self else { return }
                switch result {
                    case .success(let image):
                        var mTobacco = tobacco
                        mTobacco.image = image
                        self.tobaccos[index] = mTobacco
                        self.presenter.receivedUpdate(for: mTobacco, at: index)
                    case .failure(let error):
                        let err = error as NSError
                        self.presenter.receivedError(with: err.code, and: err.localizedDescription)
                }
            }
        }
    }
}

// MARK: - InputProtocol implementation 
extension DetailInfoManufacturerInteractor: DetailInfoManufacturerInteractorInputProtocol {
    func receiveStartingDataView() {
        presenter.initialDataForPresentation(manufacturer)
    }
}

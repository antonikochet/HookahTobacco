//
//
//  TobaccoListInteractor.swift
//  HookahTobacco
//
//  Created by антон кочетков on 26.10.2022.
//
//

import Foundation

protocol TobaccoListInteractorInputProtocol: AnyObject {
    func startReceiveData()
    func receiveDataForShowDetail(by index: Int)
    func receivedDataFromOutside(_ data: Tobacco)
    func updateData()
}

protocol TobaccoListInteractorOutputProtocol: AnyObject {
    func receivedSuccess(_ data: [Tobacco])
    func receivedError(with code: Int, and message: String)
    func receivedError(with message: String)
    func receivedUpdate(for data: Tobacco, at index: Int)
    func receivedDataForShowDetail(_ tobacco: Tobacco)
    func receivedDataForEditing(_ tobacco: Tobacco)
}

class TobaccoListInteractor {
    // MARK: - Public properties
    weak var presenter: TobaccoListInteractorOutputProtocol!
    
    // MARK: - Dependency
    private var getDataManager: GetDataBaseNetworkingProtocol
    private var getImageManager: GetImageDataBaseProtocol
    
    // MARK: - Private properties
    private var tobaccos: [Tobacco] = []
    private var isAdminMode: Bool
    
    // MARK: - Initializers
    init(_ isAdminModel: Bool,
         getDataManager: GetDataBaseNetworkingProtocol,
         getImageManager: GetImageDataBaseProtocol) {
        self.isAdminMode = isAdminModel
        self.getDataManager = getDataManager
        self.getImageManager = getImageManager
    }
    
    // MARK: - Private methods
    private func getTobacco() {
        getDataManager.getAllTobaccos { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let data):
                    self.tobaccos = data
                    self.getImagesTobacco()
                    DispatchQueue.main.async {
                        self.presenter.receivedSuccess(data)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.presenter.receivedError(with: error.localizedDescription)
                    }
            }
        }
    }
    
    private func getImage(for tobacco: Tobacco, with index: Int) {
        guard let uid = tobacco.uid else { return }
        let named = NamedFireStorage.tobaccoImage(manufacturer: tobacco.nameManufacturer,
                                                  uid: uid,
                                                  type: .main)
        getImageManager.getImage(for: named) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let image):
                    var mutableTobacco = tobacco
                    mutableTobacco.image = image
                    self.tobaccos[index] = mutableTobacco
                    DispatchQueue.main.async {
                        self.presenter.receivedUpdate(for: mutableTobacco, at: index)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                            self.presenter.receivedError(with: error.localizedDescription)
                    }
                }
        }
    }
    
    private func getImagesTobacco() {
        for (i,t) in tobaccos.enumerated() {
            getImage(for: t, with: i)
        }
    }
}

// MARK: - InputProtocol implementation 
extension TobaccoListInteractor: TobaccoListInteractorInputProtocol {
    func startReceiveData() {
        getTobacco()
    }
    
    func receiveDataForShowDetail(by index: Int) {
        if isAdminMode {
            presenter.receivedDataForEditing(tobaccos[index])
        } else {
            presenter.receivedDataForShowDetail(tobaccos[index])
        }
    }
    
    func receivedDataFromOutside(_ data: Tobacco) {
        guard let index = tobaccos.firstIndex(where: { $0.uid == data.uid }) else { return }
        tobaccos[index] = data
        presenter.receivedUpdate(for: data, at: index)
    }
    
    func updateData() {
        getTobacco()
    }
}

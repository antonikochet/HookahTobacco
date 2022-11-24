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
    func receivedSuccess(_ data: [TobaccoListEntity.Tobacco])
    func receivedError(with message: String)
    func receivedUpdate(for data: TobaccoListEntity.Tobacco, at index: Int)
    func receivedDataForShowDetail(_ tobacco: Tobacco)
    func receivedDataForEditing(_ tobacco: Tobacco)
}

class TobaccoListInteractor {
    // MARK: - Public properties
    weak var presenter: TobaccoListInteractorOutputProtocol!
    
    // MARK: - Dependency
    private var getDataManager: DataManagerProtocol
    private var getImageManager: ImageManagerProtocol
    
    // MARK: - Private properties
    private var tobaccos: [Tobacco] = []
    private var tastes: Dictionary<Int, Taste> = [:]
    private var isAdminMode: Bool
    
    // MARK: - Initializers
    init(_ isAdminModel: Bool,
         getDataManager: DataManagerProtocol,
         getImageManager: ImageManagerProtocol) {
        self.isAdminMode = isAdminModel
        self.getDataManager = getDataManager
        self.getImageManager = getImageManager
        receiveTastes()
    }
    
    // MARK: - Private methods
    private func createTobaccoForPresenter(_ tobacco: Tobacco) -> TobaccoListEntity.Tobacco {
        let tasty = tobacco.taste
            .compactMap { tastes[$0] }
        return TobaccoListEntity.Tobacco(name: tobacco.name,
                                         nameManufacturer: tobacco.nameManufacturer,
                                         tasty: tasty,
                                         image: tobacco.image)
    }
    
    private func getTobacco() {
        getDataManager.receiveData(typeData: Tobacco.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let data):
                    self.tobaccos = data
                    self.getImagesTobacco()
                    DispatchQueue.main.async {
                        self.presenter.receivedSuccess(data.map { self.createTobaccoForPresenter($0) })
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.presenter.receivedError(with: error.localizedDescription)
                    }
            }
        }
    }
    
    private func receiveTastes() {
        getDataManager.receiveData(typeData: Taste.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let data):
                    self.tastes = Dictionary(uniqueKeysWithValues: data.map { ($0.uid, $0) })
                case .failure(let error):
                    self.presenter.receivedError(with: error.localizedDescription)
            }
        }
    }
    
    private func getImage(for tobacco: Tobacco, with index: Int) {
        guard let uid = tobacco.uid else { return }
        let named = NamedImageManager.tobaccoImage(manufacturer: tobacco.nameManufacturer,
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
                        self.presenter.receivedUpdate(for: self.createTobaccoForPresenter(mutableTobacco), at: index)
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
        presenter.receivedUpdate(for: createTobaccoForPresenter(data), at: index)
    }
    
    func updateData() {
        getTobacco()
    }
}

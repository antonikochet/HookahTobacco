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
    func receivedTobacco(with tobaccos: [DetailInfoManufacturerEntity.Tobacco])
    func receivedError(with message: String)
    func receivedUpdate(for tobacco: DetailInfoManufacturerEntity.Tobacco, at index: Int)
}

class DetailInfoManufacturerInteractor {
    // MARK: - Public properties
    weak var presenter: DetailInfoManufacturerInteractorOutputProtocol!
    
    // MARK: - Dependency
    private var getDataManager: DataManagerProtocol
    private var getImageManager: ImageManagerProtocol
    
    // MARK: - Private properties
    private var manufacturer: Manufacturer
    private var tobaccos: [Tobacco] = []
    private var tastes: Dictionary<Int, Taste> = [:]
    
    // MARK: - Initializers
    init(_ manufacturer: Manufacturer,
         getDataManager: DataManagerProtocol,
         getImageManager: ImageManagerProtocol) {
        self.manufacturer = manufacturer
        self.getDataManager = getDataManager
        self.getImageManager = getImageManager
        receiveTastes()
        receiveTobacco()
    }
    
    // MARK: - Private methods
    private func createTobaccoForPresenter(_ tobacco: Tobacco) -> DetailInfoManufacturerEntity.Tobacco {
        let tasty = tobacco.taste
            .compactMap { tastes[$0] }
        return DetailInfoManufacturerEntity.Tobacco(name: tobacco.name,
                                             tasty: tasty,
                                             nameManufacturer: tobacco.nameManufacturer,
                                             image: tobacco.image)
    }
    
    private func receiveTobacco() {
        getDataManager.receiveTobaccos(for: manufacturer) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let tobaccos):
                    self.tobaccos = tobaccos
                    let pTobaccos = tobaccos.map { self.createTobaccoForPresenter($0) }
                    DispatchQueue.main.async {
                        self.presenter.receivedTobacco(with: pTobaccos)
                    }
                    self.receiveImageTobaccos(tobaccos)
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
    
    private func receiveImageTobaccos(_ tobaccos: [Tobacco]) {
        tobaccos.enumerated().forEach { index, tobacco in
            let named = NamedImageManager.tobaccoImage(manufacturer: tobacco.nameManufacturer,
                                                       uid: tobacco.uid!,
                                                       type: .main)
            getImageManager.getImage(for: named) { [weak self] result in
                guard let self = self else { return }
                switch result {
                    case .success(let image):
                        var mTobacco = tobacco
                        mTobacco.image = image
                        self.tobaccos[index] = mTobacco
                        DispatchQueue.main.async {
                            self.presenter.receivedUpdate(for: self.createTobaccoForPresenter(mTobacco), at: index)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.presenter.receivedError(with: error.localizedDescription)
                        }
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

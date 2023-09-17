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
    func updateFavorite(by index: Int)
}

protocol DetailInfoManufacturerInteractorOutputProtocol: PresenterrProtocol {
    func initialDataForPresentation(_ manufacturer: Manufacturer)
    func receivedTobacco(with tobaccos: [Tobacco])
    func receivedUpdate(for tobacco: Tobacco, at index: Int)
}

class DetailInfoManufacturerInteractor {
    // MARK: - Public properties
    weak var presenter: DetailInfoManufacturerInteractorOutputProtocol!

    // MARK: - Dependency
    private var getDataNetworkingService: GetDataNetworkingServiceProtocol
    private var userNetworkingService: UserNetworkingServiceProtocol

    // MARK: - Private properties
    private var manufacturer: Manufacturer
    private var tobaccos: [Tobacco] = []

    // MARK: - Initializers
    init(_ manufacturer: Manufacturer,
         getDataNetworkingService: GetDataNetworkingServiceProtocol,
         userNetworkingService: UserNetworkingServiceProtocol) {
        self.manufacturer = manufacturer
        self.getDataNetworkingService = getDataNetworkingService
        self.userNetworkingService = userNetworkingService
        receiveTobacco()
    }

    // MARK: - Private methods
    private func receiveTobacco() {
        getDataNetworkingService.receiveTobaccos(for: manufacturer) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let tobaccos):
                self.tobaccos = tobaccos
                self.presenter.receivedTobacco(with: tobaccos)
                self.receiveImageTobaccos(tobaccos)
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
    }

    private func receiveImageTobaccos(_ tobaccos: [Tobacco]) {
        tobaccos.enumerated().forEach { index, tobacco in
            getDataNetworkingService.receiveImage(for: tobacco.imageURL) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let image):
                    var mTobacco = tobacco
                    mTobacco.image = image
                    self.tobaccos[index] = mTobacco
                    self.presenter.receivedUpdate(for: mTobacco, at: index)
                case .failure(let error):
                    self.presenter.receivedError(error)
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

    func updateFavorite(by index: Int) {
        guard index < tobaccos.count else { return }
        var tobacco = tobaccos[index]
        tobacco.isFlagsChanged = true
        tobacco.isFavorite.toggle()
        userNetworkingService.updateFavoriteTobacco([tobacco]) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let tobaccos):
                guard var newTobacco = tobaccos.first else { return }
                newTobacco.image = tobacco.image
                self.tobaccos[index] = newTobacco
                self.presenter.receivedUpdate(for: newTobacco, at: index)
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
    }
}

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
    func updateFavorite(by index: Int)
}

protocol TobaccoListInteractorOutputProtocol: AnyObject {
    func receivedSuccess(_ data: [Tobacco])
    func receivedError(with message: String)
    func receivedUpdate(for data: Tobacco, at index: Int)
    func receivedDataForShowDetail(_ tobacco: Tobacco)
    func receivedDataForEditing(_ tobacco: Tobacco)
}

class TobaccoListInteractor {
    // MARK: - Public properties
    weak var presenter: TobaccoListInteractorOutputProtocol!

    // MARK: - Dependency
    private var getDataManager: DataManagerProtocol
    private var getImageManager: ImageManagerProtocol
    private var updateDataManager: ObserverProtocol

    // MARK: - Private properties
    private var tobaccos: [Tobacco] = []
    private var isAdminMode: Bool

    // MARK: - Initializers
    init(_ isAdminModel: Bool,
         getDataManager: DataManagerProtocol,
         getImageManager: ImageManagerProtocol,
         updateDataManager: ObserverProtocol
    ) {
        self.isAdminMode = isAdminModel
        self.getDataManager = getDataManager
        self.getImageManager = getImageManager
        self.updateDataManager = updateDataManager
        self.updateDataManager.subscribe(to: Tobacco.self, subscriber: self)
    }

    deinit {
        self.updateDataManager.unsubscribe(to: Tobacco.self, subscriber: self)
    }

    // MARK: - Private methods
    private func getTobacco() {
        getDataManager.receiveData(typeData: Tobacco.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.tobaccos = data
                self.presenter.receivedSuccess(data)
                self.getImagesTobacco()
            case .failure(let error):
                self.presenter.receivedError(with: error.localizedDescription)
            }
        }
    }

    private func getImage(for tobacco: Tobacco, with index: Int) {
        guard !tobacco.uid.isEmpty else { return }
        let named = NamedImageManager.tobaccoImage(manufacturer: tobacco.nameManufacturer,
                                                   uid: tobacco.uid,
                                                   type: .main)
        getImageManager.getImage(for: named) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                var mutableTobacco = tobacco
                mutableTobacco.image = image
                self.tobaccos[index] = mutableTobacco
                self.presenter.receivedUpdate(for: mutableTobacco, at: index)
            case .failure(let error):
                self.presenter.receivedError(with: error.localizedDescription)
            }
        }
    }

    private func getImagesTobacco() {
        for (index, tobacco) in tobaccos.enumerated() {
            getImage(for: tobacco, with: index)
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

    func updateFavorite(by index: Int) {
        guard index < tobaccos.count else { return }
        var tobacco = tobaccos[index]
        tobacco.isFavoriteChanged = true
        tobacco.isFavorite.toggle()
        getDataManager.updateFavorite(for: tobacco) { [weak self] error in
            guard let self = self else { return }
            if let error {
                self.presenter?.receivedError(with: error.localizedDescription)
                return
            }
            self.tobaccos[index].isFavorite.toggle()
            self.presenter.receivedUpdate(for: self.tobaccos[index], at: index)
        }
    }
}

    // MARK: - UpdateDataSubscriberProtocol implementation
extension TobaccoListInteractor: UpdateDataSubscriberProtocol {
    func notify<T>(for type: T.Type, notification: UpdateDataNotification<[T]>) {
        switch notification {
        case .update(let data):
            if let newTobacco = data as? [Tobacco] {
                tobaccos = newTobacco
                presenter.receivedSuccess(newTobacco)
                getImagesTobacco()
            }
        case .error(let error):
                presenter.receivedError(with: error.localizedDescription)
        }
    }
}

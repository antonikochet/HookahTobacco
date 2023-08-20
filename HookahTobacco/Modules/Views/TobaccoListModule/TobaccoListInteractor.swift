//
//
//  TobaccoListInteractor.swift
//  HookahTobacco
//
//  Created by антон кочетков on 26.10.2022.
//
//

import Foundation

enum TobaccoListInput {
    case none
    case favorite
    case wantBuy
}

protocol TobaccoListInteractorInputProtocol: AnyObject {
    func startReceiveData()
    func receiveDataForShowDetail(by index: Int)
    func receivedDataFromOutside(_ data: Tobacco)
    func updateData()
    func updateFavorite(by index: Int)
    func updateWantBuy(by index: Int)
}

protocol TobaccoListInteractorOutputProtocol: PresenterrProtocol {
    func receivedSuccess(_ data: [Tobacco])
    func receivedUpdate(for data: Tobacco, at index: Int)
    func receivedDataForShowDetail(_ tobacco: Tobacco)
    func receivedDataForEditing(_ tobacco: Tobacco)
    func showMessageUser(_ message: String)
    func removeTobacco(at index: Int)
}

class TobaccoListInteractor {
    // MARK: - Public properties
    weak var presenter: TobaccoListInteractorOutputProtocol!

    // MARK: - Dependency
    private var getDataManager: DataManagerProtocol
    private var userService: UserNetworkingServiceProtocol
    private var updateDataManager: ObserverProtocol

    // MARK: - Private properties
    private var tobaccos: [Tobacco] = []
    private var isAdminMode: Bool
    private var input: TobaccoListInput

    // MARK: - Initializers
    init(_ isAdminModel: Bool,
         input: TobaccoListInput,
         getDataManager: DataManagerProtocol,
         userService: UserNetworkingServiceProtocol,
         updateDataManager: ObserverProtocol
    ) {
        self.isAdminMode = isAdminModel
        self.input = input
        self.getDataManager = getDataManager
        self.userService = userService
        self.updateDataManager = updateDataManager
        self.updateDataManager.subscribe(to: Tobacco.self, subscriber: self)
    }

    deinit {
        self.updateDataManager.unsubscribe(to: Tobacco.self, subscriber: self)
    }

    // MARK: - Private methods
    private func getTobacco() {
        let completion: CompletionResultBlock<[Tobacco]> = { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let tobaccos):
                self.tobaccos = tobaccos
                self.presenter.receivedSuccess(tobaccos)
                self.getImagesTobacco()
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
        switch input {
        case .none:
            getDataManager.receiveData(typeData: Tobacco.self, completion: completion)
        case .favorite:
            userService.receiveFavoriteTobaccos(completion: completion)
        case .wantBuy:
            userService.receiveWantToBuyTobaccos(completion: completion)
        }
    }

    private func getImage(for tobacco: Tobacco, with index: Int) {
        getDataManager.receiveImage(for: tobacco.imageURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                var mutableTobacco = tobacco
                mutableTobacco.image = image
                self.tobaccos[index] = mutableTobacco
                self.presenter.receivedUpdate(for: mutableTobacco, at: index)
            case .failure(let error):
                self.presenter.receivedError(error)
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
        tobacco.isFlagsChanged = true
        tobacco.isFavorite.toggle()
        getDataManager.updateFavorite(for: tobacco) { [weak self] error in
            guard let self = self else { return }
            if let error {
                self.presenter.receivedError(error)
                return
            }
            if self.input != .favorite {
                self.tobaccos[index].isFavorite.toggle()
                self.presenter.receivedUpdate(for: self.tobaccos[index], at: index)
            } else {
                self.tobaccos.remove(at: index)
                self.presenter.removeTobacco(at: index)
            }
        }
    }

    func updateWantBuy(by index: Int) {
        guard index < tobaccos.count else { return }
        var tobacco = tobaccos[index]
        tobacco.isFlagsChanged = true
        tobacco.isWantBuy.toggle()
        getDataManager.updateFavorite(for: tobacco) { [weak self] error in
            guard let self = self else { return }
            if let error {
                self.presenter.receivedError(error)
                return
            }
            if self.input != .wantBuy {
                self.tobaccos[index].isWantBuy.toggle()
                self.presenter.receivedUpdate(for: self.tobaccos[index], at: index)
                if self.tobaccos[index].isWantBuy {
                    self.presenter.showMessageUser("Вы добавили табак в список \"Хочу купить\"")
                } else {
                    self.presenter.showMessageUser("Вы убрали табак из списка \"Хочу купить\"")
                }
            } else {
                self.tobaccos.remove(at: index)
                self.presenter.removeTobacco(at: index)
                self.presenter.showMessageUser("Вы убрали табак из списка \"Хочу купить\"")
            }
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
                presenter.receivedSuccess(tobaccos)
                getImagesTobacco()
            }
        case .error(let error):
                presenter.receivedError(error)
        }
    }
}

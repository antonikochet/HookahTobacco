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
    func receiveNextPage()
    func receiveDataForShowDetail(by index: Int)
    func receivedDataFromOutside(_ data: Tobacco)
    func updateData()
    func updateFavorite(by index: Int)
    func updateWantBuy(by index: Int)
    func receiveTobaccoListInput() -> TobaccoListInput
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
    private var getDataNetworkingService: GetDataNetworkingServiceProtocol
    private var userService: UserNetworkingServiceProtocol
    private var updateDataManager: ObserverProtocol

    // MARK: - Private properties
    private var tobaccos: [Tobacco] = []
    private var isAdminMode: Bool
    private var input: TobaccoListInput
    private var page: Int = 0

    // MARK: - Initializers
    init(_ isAdminModel: Bool,
         input: TobaccoListInput,
         getDataNetworkingService: GetDataNetworkingServiceProtocol,
         userService: UserNetworkingServiceProtocol,
         updateDataManager: ObserverProtocol
    ) {
        self.isAdminMode = isAdminModel
        self.input = input
        self.getDataNetworkingService = getDataNetworkingService
        self.userService = userService
        self.updateDataManager = updateDataManager
        self.updateDataManager.subscribe(to: Tobacco.self, subscriber: self)
    }

    deinit {
        self.updateDataManager.unsubscribe(to: Tobacco.self, subscriber: self)
    }

    // MARK: - Private methods
    private func getTobacco() {
        let completion: CompletionResultBlock<PageResponse<Tobacco>> = { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                self.page = response.next ?? -1
                self.tobaccos.append(contentsOf: response.results)
                self.presenter.receivedSuccess(self.tobaccos)
                self.getImagesTobacco()
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
        if page != -1 {
            switch input {
            case .none:
                getDataNetworkingService.receivePagesData(type: Tobacco.self, page: page, completion: completion)
            case .favorite:
                userService.receiveFavoriteTobaccos(page: page, completion: completion)
            case .wantBuy:
                userService.receiveWantToBuyTobaccos(page: page, completion: completion)
            }
        }
    }

    private func getImage(for tobacco: Tobacco, with index: Int) {
        getDataNetworkingService.receiveImage(for: tobacco.imageURL) { [weak self] result in
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
        page = 1
        tobaccos = []
        getTobacco()
    }

    func receiveNextPage() {
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
        page = 1
        tobaccos = []
        getTobacco()
    }

    func updateFavorite(by index: Int) {
        guard index < tobaccos.count else { return }
        var tobacco = tobaccos[index]
        tobacco.isFlagsChanged = true
        tobacco.isFavorite.toggle()
        userService.updateFavoriteTobacco([tobacco]) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let tobaccos):
                guard var newTobacco = tobaccos.first else { return }
                newTobacco.image = tobacco.image
                if self.input != .favorite {
                    self.tobaccos[index] = newTobacco
                    self.presenter.receivedUpdate(for: newTobacco, at: index)
                } else {
                    self.tobaccos.remove(at: index)
                    self.presenter.removeTobacco(at: index)
                }
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
    }

    func updateWantBuy(by index: Int) {
        guard index < tobaccos.count else { return }
        var tobacco = tobaccos[index]
        tobacco.isFlagsChanged = true
        tobacco.isWantBuy.toggle()
        userService.updateWantToBuyTobacco([tobacco]) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let tobaccos):
                guard var newTobacco = tobaccos.first else { return }
                newTobacco.image = tobacco.image
                if self.input != .wantBuy {
                    self.tobaccos[index] = newTobacco
                    self.presenter.receivedUpdate(for: newTobacco, at: index)
                    if newTobacco.isWantBuy {
                        self.presenter.showMessageUser("Вы добавили табак в список \"Хочу купить\"")
                    } else {
                        self.presenter.showMessageUser("Вы убрали табак из списка \"Хочу купить\"")
                    }
                } else {
                    self.tobaccos.remove(at: index)
                    self.presenter.removeTobacco(at: index)
                    self.presenter.showMessageUser("Вы убрали табак из списка \"Хочу купить\"")
                }
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
    }

    func receiveTobaccoListInput() -> TobaccoListInput {
        input
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

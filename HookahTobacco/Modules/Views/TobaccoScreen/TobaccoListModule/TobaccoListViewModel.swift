//
//
//  TobaccoListViewModel.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 07.07.2024.
//
//

import Foundation

protocol TobaccoListViewModel: BaseViewModel {
    var tobaccos: [TobaccoViewModel] { get }
    func startReceiveTobacco()
    func receiveNextPage()
    func showDetail(id: String)
}

final class TobaccoListViewModelImpl: BaseViewModelImpl, TobaccoListViewModel {
    // MARK: - ViewModel properties
    @Published private(set) var tobaccos: [TobaccoViewModel] = []
    
    // MARK: - Private properties
    private var privateTobaccos: [Tobacco] = [] {
        didSet {
            tobaccos = privateTobaccos.map(createTobaccoViewModel)
        }
    }
    private var page: Int = 0
    private var filters: TobaccoFilters?
    private var isDownloadData: Bool = false
    
    // MARK: - Dependency
    private var getDataNetworkingService: GetDataNetworkingServiceProtocol
    private var userService: UserNetworkingServiceProtocol
    
    // MARK: - Routing
    private var showDetailTobacco: CompletionBlockWithParam<Tobacco>
    
    // MARK: - Initializers
    init(
        getDataNetworkingService: GetDataNetworkingServiceProtocol,
        userService: UserNetworkingServiceProtocol,
        showDetailTobacco: @escaping CompletionBlockWithParam<Tobacco>
    ) {
        self.getDataNetworkingService = getDataNetworkingService
        self.userService = userService
        self.showDetailTobacco = showDetailTobacco
    }
    
    // MARK: - ViewModel methods
    func startReceiveTobacco() {
        page = 1
        privateTobaccos = []
        getTobacco()
    }
    
    func receiveNextPage() {
        getTobacco()
    }
    
    func showDetail(id: String) {
        guard let tobacco = privateTobaccos.first(where: { $0.id == id}) else { return }
        showDetailTobacco(tobacco)
    }
    
    // MARK: - Private methods
    private func getTobacco(searchText: String? = nil) {
        let completion: CompletionResultBlock<PageResponse<Tobacco>> = { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                self.page = response.next ?? -1
                privateTobaccos.append(contentsOf: response.results)
                self.isDownloadData = true
            case .failure(let error):
                self.handlerError(error)
            }
            self.isLoading = false
        }
        isLoading = true
        if page != -1 {
            getDataNetworkingService.receiveTobacco(
                page: page,
                search: searchText,
                filters: filters,
                completion: completion
            )
        }
    }
    
    private func updateFavorite(_ id: String) {
        guard let index = privateTobaccos.firstIndex(where: { $0.id == id }) else { return }
        var tobacco = privateTobaccos[index]
        tobacco.isFlagsChanged = true
        tobacco.isFavorite.toggle()
        isLoading = true
        userService.updateFavoriteTobacco([tobacco]) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let tobaccos):
                guard var newTobacco = tobaccos.first else { return }
                guard self.privateTobaccos.count > index else { return }
                self.privateTobaccos[index] = newTobacco
            case .failure(let error):
                self.handlerError(error)
            }
            self.isLoading = false
        }
    }
    
    private func updateWantBuy(_ id: String) {
        guard let index = privateTobaccos.firstIndex(where: { $0.id == id }) else { return }
        var tobacco = privateTobaccos[index]
        tobacco.isFlagsChanged = true
        tobacco.isWantBuy.toggle()
        isLoading = true
        userService.updateWantToBuyTobacco([tobacco]) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let tobaccos):
                guard var newTobacco = tobaccos.first else { return }
                guard self.privateTobaccos.count > index else { return }
                self.privateTobaccos[index] = newTobacco
            case .failure(let error):
                self.handlerError(error)
            }
            self.isLoading = false
        }
    }
    
    // MARK: - Helper methods
    private func handlerError(_ error: HTError) {
        switch error {
        case .noInternetConnection, .unexpectedError, .unknownError, .serverNotAvailable:
            if isDownloadData {
                showAlertError(message: error.message)
            } else {
                showErrorView(isUnexpectedError: error != .noInternetConnection) { [weak self] in
                    self?.infoView = nil
                    self?.startReceiveTobacco()
                }
            }
        default:
            showAlertError(message: error.message)
        }
    }
    
    private func createTobaccoViewModel(_ tobacco: Tobacco) -> TobaccoViewModel {
        var viewModel = TobaccoViewModel(
            id: tobacco.id,
            imageURL: tobacco.description,
            name: tobacco.name,
            tasty: tobacco.tastes.map { $0.taste }.joined(separator: ", "),
            manufacturerName: tobacco.nameManufacturer,
            isFavorite: tobacco.isFavorite,
            isWantBuy: tobacco.isWantBuy,
            isShowWantBuyButton: true
        )
        viewModel.favoriteAction = { [weak self] in
            self?.updateFavorite(tobacco.id)
        }
        viewModel.wantBuyAction = { [weak self] in
            self?.updateWantBuy(tobacco.id)
        }
        return viewModel
    }
}

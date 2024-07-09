//
//
//  TobaccoListViewModel.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 07.07.2024.
//
//

import Foundation
import Combine

enum TobaccoListInput {
    case none
    case favorite
    case wantBuy
}

protocol TobaccoListViewModel: BaseViewModel {
    var tobaccos: [TobaccoViewModel] { get }
    var hasFilter: Bool { get }
    var title: String { get }
    var isShowSearch: Bool { get }
    var search: String { get set }
    func startReceiveTobacco()
    func receiveNextPage()
    func refresh()
    
    func showDetail(id: String)
    func showFilter()
}

final class TobaccoListViewModelImpl: BaseViewModelImpl, TobaccoListViewModel {
    // MARK: - ViewModel properties
    @Published private(set) var tobaccos: [TobaccoViewModel] = []
    @Published private(set) var hasFilter: Bool = false
    @Published var search: String = ""
    
    private(set) var title: String
    private(set) var isShowSearch: Bool
    
    // MARK: - Private properties
    private var privateTobaccos: [Tobacco] = []
    private var page: Int = 0
    private var input: TobaccoListInput
    private var filters: TobaccoFilters? {
        didSet {
            if let filters, !filters.isAllEmpty {
                hasFilter = true
            } else {
                hasFilter = false
            }
        }
    }
    private var isDownloadData: Bool = false
    
    var subscription: Set<AnyCancellable> = []
    
    // MARK: - Dependency
    private var getDataNetworkingService: GetDataNetworkingServiceProtocol
    private var userService: UserNetworkingServiceProtocol
    
    // MARK: - Routing
    private var showDetailTobacco: BlockWithParam<Tobacco>
    private var showFilterTobacco: BlockWithParam<(filters: TobaccoFilters?, delegate: TobaccoFiltersOutputModule)>
    
    // MARK: - Initializers
    init(
        input: TobaccoListInput,
        getDataNetworkingService: GetDataNetworkingServiceProtocol,
        userService: UserNetworkingServiceProtocol,
        showDetailTobacco: @escaping BlockWithParam<Tobacco>,
        showFilterTobacco: @escaping BlockWithParam<(filters: TobaccoFilters?, delegate: TobaccoFiltersOutputModule)>
    ) {
        self.input = input
        self.getDataNetworkingService = getDataNetworkingService
        self.userService = userService
        self.showDetailTobacco = showDetailTobacco
        self.showFilterTobacco = showFilterTobacco
        
        let title: String
        switch input {
        case .none:
            title = R.string.localizable.titleNone()
        case .favorite:
            title = R.string.localizable.titleFavorite()
        case .wantBuy:
            title = R.string.localizable.titleWantBuy()
        }
        self.title = title
        self.isShowSearch = input == .none
        
        super.init()
        
        $search
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] search in
                self?.startReceiveTobacco()
            }.store(in: &subscription)
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
    
    func refresh() {
        startReceiveTobacco()
    }
    
    func showDetail(id: String) {
        guard let tobacco = privateTobaccos.first(where: { $0.id == id}) else { return }
        showDetailTobacco(tobacco)
    }
    
    func showFilter() {
        showFilterTobacco((filters, self))
    }
    
    // MARK: - Private methods
    private func getTobacco() {
        let completion: ResultBlock<PageResponse<Tobacco>> = { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                self.handlerSuccess(response)
            case .failure(let error):
                self.handlerError(error)
            }
            self.isLoading = false
        }
        if page != -1 {
            isLoading = true
            switch input {
            case .none:
                getDataNetworkingService.receiveTobacco(
                    page: page,
                    search: search,
                    filters: filters,
                    completion: completion
                )
            case .favorite:
                userService.receiveFavoriteTobaccos(page: page, completion: completion)
            case .wantBuy:
                userService.receiveWantToBuyTobaccos(page: page, completion: completion)
            }
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
                guard let newTobacco = tobaccos.first else { return }
                guard self.privateTobaccos.count > index else { return }
                if self.input != .favorite {
                    self.privateTobaccos[index] = newTobacco
                    self.tobaccos[index] = createTobaccoViewModel(newTobacco)
                } else {
                    self.privateTobaccos.remove(at: index)
                    self.tobaccos.remove(at: index)
                }
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
                guard let newTobacco = tobaccos.first else { return }
                guard self.privateTobaccos.count > index else { return }
                if self.input != .wantBuy {
                    self.privateTobaccos[index] = newTobacco
                    self.tobaccos[index] = createTobaccoViewModel(newTobacco)
                    if newTobacco.isWantBuy {
                    } else {
                    }
                } else {
                    self.privateTobaccos.remove(at: index)
                    self.tobaccos.remove(at: index)
                }
                
            case .failure(let error):
                self.handlerError(error)
            }
            self.isLoading = false
        }
    }
    
    // MARK: - Helper methods
    private func handlerSuccess(_ response: PageResponse<Tobacco>) {
        if infoView != nil {
            infoView = nil
        }
        page = response.next ?? -1
        if privateTobaccos.isEmpty {
            tobaccos.removeAll()
        }
        privateTobaccos.append(contentsOf: response.results)
        tobaccos.append(contentsOf: response.results.map(createTobaccoViewModel))
        isDownloadData = true
        if privateTobaccos.isEmpty {
            setupInfoView()
        }
    }
    
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
    
    private func setupInfoView() {
        var title: String
        var message: String = ""
        var action: ActionWithTitle?
        switch input {
        case .none:
            title = R.string.localizable.infoTitleNone()
        case .favorite:
            title = R.string.localizable.infoTitleFavorite()
            message = R.string.localizable.infoMessageFavorite()
        case .wantBuy:
            title = R.string.localizable.infoTitleWantBuy()
            message = R.string.localizable.infoMessageWantBuy()
        }
        if !search.isEmpty {
            title = R.string.localizable.infoTitleSearch()
            message = R.string.localizable.infoMessageSearch()
            action = ActionWithTitle(title: R.string.localizable.infoButtonSearchTitle()) { [weak self] in
                self?.search = ""
                self?.startReceiveTobacco()
            }
        }
        
        showInfoView(
            title: title,
            message: message,
            image: R.image.notFound.name,
            primaryAction: action
        )
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

extension TobaccoListViewModelImpl: TobaccoFiltersOutputModule {
    func receiveFilter(_ filters: TobaccoFilters?) {
        self.filters = filters
        startReceiveTobacco()
    }
}

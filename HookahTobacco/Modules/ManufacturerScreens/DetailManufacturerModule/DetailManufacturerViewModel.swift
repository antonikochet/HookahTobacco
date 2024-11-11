//
//
//  DetailManufacturerViewModel.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 17.07.2024.
//
//

import Foundation
import HookahTobaccoCore

protocol DetailManufacturerViewModel: BaseViewModel {
    var title: String { get }
    var imageURL: String { get }
    var country: String { get }
    var description: String { get }
    var link: String { get }
    var tobaccoLines: [DetailManufacturerTobaccoLineViewModel] { get }
    
    func showDetail(id: Int)
}

final class DetailManufacturerViewModelImpl: BaseViewModelImpl, DetailManufacturerViewModel {
    // MARK: - ViewModel properties
    @Published private(set) var title: String
    @Published private(set) var imageURL: String
    @Published private(set) var country: String
    @Published private(set) var description: String
    @Published private(set) var link: String
    @Published private(set) var tobaccoLines: [DetailManufacturerTobaccoLineViewModel] = []
    
    // MARK: - Private properties
    private let manufacturer: Manufacturer
    private var tobaccos: [Tobacco] = []
    
    // MARK: - Dependency
    private let manufacturerRepo: ManufacturerRepoProtocol
    private let favoriteTobaccoRepo: FavoriteTobaccoRepoProtocol
    private var imageManager: ImageManagerProtocol
    
    // MARK: - Routing
    private var showDetailTobacco: BlockWithParam<Tobacco>
    
    // MARK: - Initializers
    init(
        manufacturer: Manufacturer,
        manufacturerRepo: ManufacturerRepoProtocol,
        favoriteTobaccoRepo: FavoriteTobaccoRepoProtocol,
        imageManager: ImageManagerProtocol,
        showDetailTobacco: @escaping BlockWithParam<Tobacco>
    ) {
        self.manufacturer = manufacturer
        self.manufacturerRepo = manufacturerRepo
        self.favoriteTobaccoRepo = favoriteTobaccoRepo
        self.imageManager = imageManager
        self.showDetailTobacco = showDetailTobacco
        
        self.title = manufacturer.name
        self.imageURL = manufacturer.urlImage
        self.country = R.string.localizable.manufacteurerDetailCountryTitle(manufacturer.country.name)
        self.description = manufacturer.description
        self.link = manufacturer.link ?? ""
        
        super.init()
        
        self.receiveTobacco()
    }
    
    // MARK: - ViewModel methods
    func showDetail(id: Int) {
        guard let tobacco = tobaccos.first(where: { $0.id == id }) else { return }
        showDetailTobacco(tobacco)
    }
    
    // MARK: - Private methods
    private func receiveTobacco() {
        isLoading = true
        manufacturerRepo.fetchTobaccos(for: manufacturer) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let tobaccos):
                self.handlerSuccess(tobaccos)
            case .failure(let error):
                self.handlerError(error)
            }
            self.isLoading = false
        }
    }
    
    private func updateFavorite(id: Int) {
        guard let index = tobaccos.firstIndex(where: { $0.id == id }) else { return }
        var tobacco = tobaccos[index]
        tobacco.isFavorite.toggle()
        isLoading = true
        favoriteTobaccoRepo.update(tobaccos: [tobacco]) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let tobaccos):
                guard let newTobacco = tobaccos.first else { return }
                self.tobaccos[index] = newTobacco
                self.updateTobaccoLines()
            case .failure(let error):
                self.handlerError(error)
            }
            self.isLoading = false
        }
    }
    
    private func handlerSuccess(_ tobaccos: [Tobacco]) {
        self.tobaccos = tobaccos
        updateTobaccoLines()
    }
    
    private func updateTobaccoLines() {
        // TODO: - убрать прыгание секций при изменения табаков
        let tobaccoDict = Dictionary(grouping: tobaccos) { tobacco in
            tobacco.line.id
        }
        
        self.tobaccoLines = tobaccoDict.values.compactMap { tobaccos -> DetailManufacturerTobaccoLineViewModel? in
            guard let line = tobaccos.first?.line else { return nil }
            
            let viewModels = tobaccos.map { tobacco in
                TobaccoViewModel(
                    tobacco,
                    isShowWantBuyButton: false,
                    favoriteAction: { [weak self] in
                        self?.updateFavorite(id: tobacco.id)
                    })
            }
            
            return DetailManufacturerTobaccoLineViewModel(
                id: line.id,
                title: line.isBase ? R.string.localizable.manufacteurerDetailBaseLineName() : line.name,
                description: line.description,
                tobaccos: viewModels
            )
        }
    }
    
    private func handlerError(_ error: DomainError) {
        showAlertError(message: error.message)
    }
}

#if DEBUG
final class DetailManufacturerViewModelMock: BaseViewModelImpl, DetailManufacturerViewModel {
    // MARK: - ViewModel properties
    @Published private(set) var title: String
    @Published private(set) var imageURL: String
    @Published private(set) var country: String
    @Published private(set) var description: String
    @Published private(set) var link: String
    @Published private(set) var tobaccoLines: [DetailManufacturerTobaccoLineViewModel]
    
    // MARK: - ViewModel methods
    func showDetail(id: Int) {
        print("show tobacco for id: \(id)")
    }
    
    // MARK: - Init
    override init() {
        let manufacturer = Manufacturer.mock(countLines: 4)
        self.title = manufacturer.name
        self.imageURL = manufacturer.urlImage
        self.country = R.string.localizable.manufacteurerDetailCountryTitle(manufacturer.country.name)
        self.description = manufacturer.description
        self.link = manufacturer.link ?? ""
        
        self.tobaccoLines = []
        self.tobaccoLines = manufacturer.lines.map { tobaccoLine in
            DetailManufacturerTobaccoLineViewModel(
                id: tobaccoLine.id,
                title: tobaccoLine.name,
                description: tobaccoLine.description,
                tobaccos: Tobacco.arrayMock(5).map { tobacco in
                        .init(
                            tobacco,
                            isShowWantBuyButton: false,
                            favoriteAction: {
                                print("update favorite for \(tobacco.id)")
                            })
                }
            )
        }
    }
}
#endif

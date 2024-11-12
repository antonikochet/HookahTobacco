//
//
//  ManufacturerListViewModel.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 16.07.2024.
//
//

import Foundation
import HookahTobaccoCore

protocol ManufacturerListViewModel: BaseViewModel {
    var manufacturers: [ManufacturerCellViewModel] { get }
    
    func startReceiveManufacturers()
    func showDetail(id: Int)
}

final class ManufacturerListViewModelImpl: BaseViewModelImpl, ManufacturerListViewModel {
    // MARK: - ViewModel properties
    @Published private(set) var manufacturers: [ManufacturerCellViewModel] = []
    
    // MARK: - Private properties
    private var privateManufacturers: [Manufacturer] = []
    private var isDownloadData = false
    
    // MARK: - Dependency
    private let manufacturerRepo: ManufacturerRepoProtocol
    
    // MARK: - Routing
    private var showDetailManufacturer: BlockWithParam<Manufacturer>
    
    // MARK: - Initializers
    init(
        manufacturerRepo: ManufacturerRepoProtocol,
        showDetailManufacturer: @escaping BlockWithParam<Manufacturer>
    ) {
        self.manufacturerRepo = manufacturerRepo
        self.showDetailManufacturer = showDetailManufacturer
    }
    
    // MARK: - ViewModel methods
    func startReceiveManufacturers() {
        receiveManufacturers()
    }
    
    func showDetail(id: Int) {
        guard let manufacturer = privateManufacturers.first(where: { $0.id == id }) else { return }
        showDetailManufacturer(manufacturer)
    }
    
    // MARK: - Private methods
    private func receiveManufacturers() {
        networkRequest { [weak self] in
            guard let self else { return }
            let result = try await self.manufacturerRepo.fetchManufacturer()
            await self.handlerSuccess(result)
        } errorClosure: { [weak self] error in
            await self?.handlerError(error)
        }
    }
    
    @MainActor
    private func handlerSuccess(_ manufacturers: [Manufacturer]) {
        isDownloadData = true
        if manufacturers.isEmpty {
            showErrorView(
                title: R.string.localizable.manufacteurerListEmptyTitle(),
                message: "",
                buttonAction: nil
            )
            return
        }
        privateManufacturers = manufacturers
        self.manufacturers = manufacturers.map {
            .init(
                id: $0.id,
                name: $0.name,
                county: $0.country.name,
                imageURL: $0.urlImage
            )
        }
    }
    
    @MainActor
    private func handlerError(_ error: DomainError) {
        switch error {
        case .error:
            showAlertError(message: error.message)
        case .noInternetConnection, .unexpectedError, .unknownError, .serverNotAvailable:
            if isDownloadData {
                showAlertError(message: error.message)
            } else {
                showErrorView(isUnexpectedError: error != .noInternetConnection) { [weak self] in
                    self?.infoView = nil
                    self?.receiveManufacturers()
                }
            }
        }
    }
}

#if DEBUG
final class ManufacturerListViewModelMock: BaseViewModelImpl, ManufacturerListViewModel {
    // MARK: - ViewModel properties
    @Published private(set) var manufacturers: [ManufacturerCellViewModel] = []
    
    // MARK: - ViewModel methods
    func startReceiveManufacturers() {
        let isEmpty = false
        
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            
            let manufacturers = Manufacturer.arrayMock(8)
            if isEmpty {
                self.showErrorView(
                    title: R.string.localizable.manufacteurerListEmptyTitle(),
                    message: "",
                    buttonAction: nil
                )
            } else {
                self.manufacturers = manufacturers.map {
                    .init(
                        id: $0.id,
                        name: $0.name,
                        county: $0.country.name,
                        imageURL: $0.urlImage
                    )
                }
            }
            self.isLoading = false
        }
    }
    
    func showDetail(id: Int) {
        
    }
}
#endif

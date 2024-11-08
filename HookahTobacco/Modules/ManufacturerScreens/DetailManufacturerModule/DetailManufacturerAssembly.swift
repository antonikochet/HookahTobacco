//
//
//  DetailManufacturerAssembly.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 17.07.2024.
//
//

import Swinject
import UIKit
import SwiftUI
import HookahTobaccoCore

final class DetailManufacturerAssembly: AssemblyProtocol {
    
    private let manufacturer: Manufacturer
    private let showDetailTobacco: BlockWithParam<Tobacco>
    
    init(
        manufacturer: Manufacturer,
        showDetailTobacco: @escaping BlockWithParam<Tobacco>
    ) {
        self.manufacturer = manufacturer
        self.showDetailTobacco = showDetailTobacco
    }
    
    func assemble(resolver: Resolver) -> UIViewController {
        let viewModel = DetailManufacturerViewModelImpl(
            manufacturer: manufacturer,
            manufacturerRepo: resolver.resolve(ManufacturerRepoProtocol.self)!,
            favoriteTobaccoRepo: resolver.resolve(FavoriteTobaccoRepoProtocol.self)!,
            imageManager: resolver.resolve(ImageManagerProtocol.self)!,
            showDetailTobacco: showDetailTobacco
        )
        let view = DetailManufacturerView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }
}

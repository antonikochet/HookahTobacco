//
//
//  ManufacturerListAssembly.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 16.07.2024.
//
//

import Swinject
import UIKit
import SwiftUI
import HookahTobaccoCore

final class ManufacturerListAssembly: AssemblyProtocol {

    private let showDetailManufacturer: BlockWithParam<Manufacturer>
    
    init(
        showDetailManufacturer: @escaping BlockWithParam<Manufacturer>
    ) {
        self.showDetailManufacturer = showDetailManufacturer
    }
    
    func assemble(resolver: Resolver) -> UIViewController {
        let viewModel = ManufacturerListViewModelImpl(
            manufacturerRepo: resolver.resolve(ManufacturerRepoProtocol.self)!,
            showDetailManufacturer: showDetailManufacturer
        )
        let view = ManufacturerListView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }
}

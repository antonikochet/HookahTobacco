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

final class DetailManufacturerAssembly: AssemblyProtocol {
    
    private let manufacturer: Manufacturer
    
    init(
        manufacturer: Manufacturer
    ) {
        self.manufacturer = manufacturer
    }
    
    func assemble(resolver: Resolver) -> UIViewController {
        let viewModel = DetailManufacturerViewModelImpl(
            manufacturer: manufacturer, 
            getDataNetworkingService: resolver.resolve(GetDataNetworkingServiceProtocol.self)!,
            userNetworkingService: resolver.resolve(UserNetworkingServiceProtocol.self)!
        )
        let view = DetailManufacturerView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }
}

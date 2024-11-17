//
//
//  RegistrationAssembly.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 17.11.2024.
//
//

import Swinject
import UIKit
import SwiftUI
import HookahTobaccoCore

final class RegistrationAssembly: AssemblyProtocol {
    
    private let showProfileRegistration: BlockWithParam<RegistrationUser>
    
    init(showProfileRegistration: @escaping BlockWithParam<RegistrationUser>) {
        self.showProfileRegistration = showProfileRegistration
    }
    
    func assemble(resolver: Resolver) -> UIViewController {
        let viewModel = RegistrationViewModelImpl(
            registrationService: resolver.resolve(RegistrationServiceProtocol.self)!,
            showProfileRegistration: showProfileRegistration
        )
        let view = RegistrationView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }
}

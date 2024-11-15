//
//
//  LoginAssembly.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 15.11.2024.
//
//

import Swinject
import UIKit
import SwiftUI
import HookahTobaccoCore

final class LoginAssembly: AssemblyProtocol {
    
    private let showProfile: VoidBlock
    private let showRegistration: VoidBlock
    
    init(
        showProfile: @escaping VoidBlock,
        showRegistration: @escaping VoidBlock
    ) {
        self.showProfile = showProfile
        self.showRegistration = showRegistration
    }
    
    func assemble(resolver: Resolver) -> UIViewController {
        let viewModel = LoginViewModelImpl(
            authService: resolver.resolve(AuthServiceProtocol.self)!,
            showProfile: showProfile,
            showRegistration: showRegistration
        )
        let view = LoginView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }
}

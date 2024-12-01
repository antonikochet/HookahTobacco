//
//
//  ProfileEditAssembly.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 17.11.2024.
//
//

import Swinject
import UIKit
import SwiftUI

final class ProfileEditAssembly: AssemblyProtocol {
    
    private let isRegistration: Bool
    
    init(
        isRegistration: Bool
    ) {
        self.isRegistration = isRegistration
    }
    
    func assemble(resolver: Resolver) -> UIViewController {
        let viewModel = ProfileEditViewModelImpl(isRegistration: isRegistration)
        let view = ProfileEditView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }
}

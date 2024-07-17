//
//  DetailTobaccoAssembly.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 16.07.2024.
//

import Swinject
import UIKit
import SwiftUI

final class DetailTobaccoAssembly: AssemblyProtocol {
    
    private let tobacco: Tobacco
    
    init(tobacco: Tobacco) {
        self.tobacco = tobacco
    }
    
    func assemble(resolver: Resolver) -> UIViewController {
        let viewModel = DetailTobaccoViewModelImpl(tobacco: tobacco)
        let view = DetailTobaccoView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }
}

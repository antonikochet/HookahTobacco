//
//
//  SuccessBottomSheetAssembly.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 19.09.2023.
//
//

import Foundation
import Swinject

struct SuccessBottomSheetDependency {
    var appRouter: AppRouterProtocol
    var item: SuccessBottomSheetViewItem?
}

class SuccessBottomSheetAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SuccessBottomSheetViewController.self) { (_, dependency: SuccessBottomSheetDependency) in
            let view = SuccessBottomSheetViewController()
            view.item = dependency.item
            return view
        }
    }
}

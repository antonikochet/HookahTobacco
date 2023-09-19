//
//
//  SuccessBottomSheetModule.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 19.09.2023.
//
//

import UIKit

struct SuccessBottomSheetDataModule: DataModuleProtocol {
    let item: SuccessBottomSheetViewItem
}

class SuccessBottomSheetModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        var dependency = SuccessBottomSheetDependency(appRouter: appRouter)
        guard let data = data as? SuccessBottomSheetDataModule else {
            fatalError("В модуль \(SuccessBottomSheetModule.nameModule) не передали данные для отображения")
        }
        dependency.item = data.item
        return appRouter.resolver.resolve(SuccessBottomSheetViewController.self,
                                          argument: dependency)
    }
}

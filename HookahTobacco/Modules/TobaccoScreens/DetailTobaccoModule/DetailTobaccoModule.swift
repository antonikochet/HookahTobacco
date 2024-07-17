//
//
//  DetailTobaccoModule.swift
//  HookahTobacco
//
//  Created by антон кочетков on 25.11.2022.
//
//

import UIKit
import SwiftUI

struct DetailTobaccoDataModule: DataModuleProtocol {
    let tobacco: Tobacco
}

class DetailTobaccoModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        guard let data = data as? DetailTobaccoDataModule else {
            print("В DetailTobaccoModule не были переданы необходимые данные")
            return nil
        }
        let assembly = DetailTobaccoAssembly(tobacco: data.tobacco)
        return assembly.assemble(resolver: appRouter.resolver)
    }
}

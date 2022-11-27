//
//  ModuleProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 09.10.2022.
//

import UIKit

protocol ModuleProtocol {
    init(_ data: DataModuleProtocol?)
    static var nameModule: String { get }
    func createModule(_ appAssembler: AppRouterProtocol) -> UIViewController?
}

protocol DataModuleProtocol {

}

extension ModuleProtocol {
    static var nameModule: String {
        String(describing: self)
    }
}

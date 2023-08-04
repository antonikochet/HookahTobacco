//
//
//  AddManufacturerRouter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import UIKit

protocol AddManufacturerRouterProtocol: RouterProtocol {
    func dismissView()
    func dismissView(with changedData: Manufacturer)
    func showError(with message: String)
    func showSuccess(delay: Double)
    func showAddCountryView()
    func showAddTobaccoLineView(for manufacturerId: Int, editing tobaccoLine: TobaccoLine?)
}

protocol AddManufacturerOutputModule: AnyObject {
    func sendChangedManufacturer(_ manufacture: Manufacturer)
}

class AddManufacturerRouter: AddManufacturerRouterProtocol {
    var appRouter: AppRouterProtocol
    weak var delegate: AddManufacturerOutputModule?

    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func dismissView() {
        appRouter.popViewConroller(animated: true, completion: nil)
    }

    func dismissView(with changedData: Manufacturer) {
        delegate?.sendChangedManufacturer(changedData)
        appRouter.popViewConroller(animated: true, completion: nil)
    }

    func showError(with message: String) {
        appRouter.presentAlert(type: .error(message: message), completion: nil)
    }

    func showSuccess(delay: Double) {
        appRouter.presentAlert(type: .success(delay: delay), completion: nil)
    }

    func showAddCountryView() {
        
    }

    func showAddTobaccoLineView(for manufacturerId: Int, editing tobaccoLine: TobaccoLine?) {
        appRouter.presentAlert(type: .systemSuccess(message: "manufacturer id: \(manufacturerId) for \(tobaccoLine?.uid ?? "nil")", delay: 5), completion: nil)
    }
}

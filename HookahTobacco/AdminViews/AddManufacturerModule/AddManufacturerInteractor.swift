//
//
//  AddManufacturerInteractor.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import Foundation

protocol AddManufacturerInteractorInputProtocol {
    func sendNewManufacturerToServer(_ data: AddManufacturerEntity.Manufacturer)
}

protocol AddManufacturerInteractorOutputProtocol: AnyObject {
    func receivedSuccessWhileAdding()
    func receivedErrorWhileAdding(with code: Int, and message: String)
}

class AddManufacturerInteractor {
    
    weak var presenter: AddManufacturerInteractorOutputProtocol!
    
    private var setNetworkManager: SetDataBaseNetworkingProtocol
    
    init(setNetworkManager: SetDataBaseNetworkingProtocol) {
        self.setNetworkManager = setNetworkManager
    }
}

extension AddManufacturerInteractor: AddManufacturerInteractorInputProtocol {
    func sendNewManufacturerToServer(_ data: AddManufacturerEntity.Manufacturer) {
        
        let manufacturer = Manufacturer(name: data.name,
                                        country: data.country,
                                        description: data.description ?? "")
        setNetworkManager.addManufacturer(manufacturer) { [weak self] error in
            guard let self = self else { return }
            if error == nil {
                self.presenter.receivedSuccessWhileAdding()
            } else {
                //TODO: создать обработку ошибок в AddManufacturerInteractor.sendNewManufacturerToServer
//                        let localError = error as?
                self.presenter.receivedErrorWhileAdding(with: 0, and: "")
            }
        }
    }
}

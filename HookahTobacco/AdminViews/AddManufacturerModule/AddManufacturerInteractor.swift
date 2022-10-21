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
    func didEnterDataManufacturer(_ data: AddManufacturerEntity.Manufacturer)
    func didSelectImage(with urlFile: URL)
}

protocol AddManufacturerInteractorOutputProtocol: AnyObject {
    func receivedSuccessWhileAdding()
    func receivedErrorWhileAdding(with code: Int, and message: String)
}

class AddManufacturerInteractor {
    
    weak var presenter: AddManufacturerInteractorOutputProtocol!
    
    private var setNetworkManager: SetDataBaseNetworkingProtocol
    private var setImageManager: SetImageDataBaseProtocol
    
    private var urlImageFile: URL?
    private var nameFileInStorage: String?
    private var manufacturer: Manufacturer?
    
    init(setNetworkManager: SetDataBaseNetworkingProtocol,
         setImageManager: SetImageDataBaseProtocol) {
        self.setNetworkManager = setNetworkManager
        self.setImageManager = setImageManager
    }
    
    private func sendImageToServer() {
        guard let manufacturer = manufacturer,
              let urlFile = urlImageFile,
              let formatImage = extractingImageFormat(from: urlFile) else { return }
        let name = "\(manufacturer.name).\(formatImage)"
        nameFileInStorage = name
        setImageManager.setImage(urlFile, for: .manufacturerImage(name: name)) { error in
            if error != nil, let error = error as? NSError {
                self.presenter.receivedErrorWhileAdding(with: error.code, and: error.localizedDescription)
            } else {
                self.sendManufacturerToServer()
            }
        }
    }
    
    private func sendManufacturerToServer() {
        guard var manufacturer = manufacturer,
              let nameFile = nameFileInStorage else { return }
        manufacturer.image = nameFile
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
    
    private func extractingImageFormat(from url: URL) -> String? {
        let absolutePath = url.absoluteString.lowercased()
        if absolutePath.hasSuffix("jpg") || absolutePath.hasSuffix("jpeg") {
            return "jpg"
        } else if absolutePath.hasSuffix("png"){
            return "png"
        } else {
           return nil
        }
    }
}

extension AddManufacturerInteractor: AddManufacturerInteractorInputProtocol {
    func didEnterDataManufacturer(_ data: AddManufacturerEntity.Manufacturer) {
        manufacturer = Manufacturer(name: data.name,
                                        country: data.country,
                                        description: data.description ?? "")
        sendImageToServer()
    }
    
    func didSelectImage(with urlFile: URL) {
        urlImageFile = urlFile
    }
}

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
    func receiveStartingDataView()
}

protocol AddManufacturerInteractorOutputProtocol: AnyObject {
    func receivedSuccess(_ isEditing: Bool)
    func receivedError(with code: Int, and message: String)
    func initialDataForPresentation(_ manufacturer: AddManufacturerEntity.Manufacturer, isEditing: Bool)
    func initialImage(_ image: Data?)
}

class AddManufacturerInteractor {
    
    weak var presenter: AddManufacturerInteractorOutputProtocol!
    
    private var setNetworkManager: SetDataBaseNetworkingProtocol
    private var setImageManager: SetImageDataBaseProtocol
    private var getImageManager: GetImageDataBaseProtocol?
    
    private var imageFileURL: URL?
    private var manufacturer: Manufacturer?
    private let isEditing: Bool
    
    private var dispatchGroup = DispatchGroup()
    private var receivedErrors: [Error] = []
    
    // init for add manufacturer
    init(setNetworkManager: SetDataBaseNetworkingProtocol,
         setImageManager: SetImageDataBaseProtocol) {
        self.setNetworkManager = setNetworkManager
        self.setImageManager = setImageManager
        self.isEditing = false
    }
    
    // init for edit manufacturer
    init(_ manufacturer: Manufacturer,
         setNetworkManager: SetDataBaseNetworkingProtocol,
         setImageManager: SetImageDataBaseProtocol,
         getImageManager: GetImageDataBaseProtocol) {
        self.manufacturer = manufacturer
        self.setNetworkManager = setNetworkManager
        self.setImageManager = setImageManager
        self.getImageManager = getImageManager
        self.isEditing = true
    }
    
    //MARK: methods for adding manufacturer data
    private func addImageToServer(with fileURL: URL, _ nameFile: String) {
        dispatchGroup.enter()
        setImageManager.addImage(by: fileURL, for: .manufacturerImage(name: nameFile)) { [weak self] error in
            guard let self = self else { return }
            if let error = error { self.receivedErrors.append(error) }
            self.dispatchGroup.leave()
        }
    }
    
    private func addManufacturerToServer(_ manufacturer: Manufacturer) {
        dispatchGroup.enter()
        setNetworkManager.addManufacturer(manufacturer) { [weak self] error in
            guard let self = self else { return }
            if let error = error { self.receivedErrors.append(error) }
            self.dispatchGroup.leave()
        }
    }
    
    private func extractingImageFormat(from url: URL) -> String {
        let absolutePath = url.absoluteString.lowercased()
        if absolutePath.hasSuffix("jpg") || absolutePath.hasSuffix("jpeg") {
            return "jpg"
        } else if absolutePath.hasSuffix("png"){
            return "png"
        } else {
            //TODO: придумать обход ошибки
           fatalError("Выбран неверный формат изображения для производителей")
        }
    }
    
    private func createNameImageFile(with fileURL: URL, for manufacturer: Manufacturer) -> String {
        let formatImage = extractingImageFormat(from: fileURL)
        return "\(manufacturer.name).\(formatImage)"
    }
    
    //MARK: methods for changing manufacturer data
    private func receiveImage(for manufacturer: Manufacturer) {
        guard let nameImage = manufacturer.image else { return }
        let type = NamedFireStorage.manufacturerImage(name: nameImage)
        getImageManager?.getImage(for: type) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let image):
                    self.presenter.initialImage(image)
                case .failure(let error):
                    let err = error as NSError
                    self.presenter.receivedError(with: err.code, and: err.localizedDescription)
            }
        }
    }
    
    private func setNameImage(oldName: String, newName: String) {
        dispatchGroup.enter()
        setImageManager.setImageName(from: .manufacturerImage(name: oldName),
                                     to: .manufacturerImage(name: newName)) { [weak self] error in
            guard let self = self else { return }
            if let error = error { self.receivedErrors.append(error) }
            self.dispatchGroup.leave()
        }
    }
    
    private func setImage(with newURL: URL, from oldName: String, to newName: String) {
        dispatchGroup.enter()
        setImageManager.setImage(from: .manufacturerImage(name: oldName),
                                 to: newURL,
                                 for: .manufacturerImage(name: newName)) { [weak self] error in
            guard let self = self else { return }
            if let error = error  { self.receivedErrors.append(error) }
            self.dispatchGroup.leave()
        }
    }
    
    private func setManufacturer(_ new: Manufacturer) {
        dispatchGroup.enter()
        setNetworkManager.setManufacturer(new) { [weak self] error in
            guard let self = self else { return }
            if let error = error { self.receivedErrors.append(error) }
            self.dispatchGroup.leave()
        }
    }
}

extension AddManufacturerInteractor: AddManufacturerInteractorInputProtocol {
    func didEnterDataManufacturer(_ data: AddManufacturerEntity.Manufacturer) {
        var enterManufacturer = Manufacturer(name: data.name,
                                        country: data.country,
                                        description: data.description ?? "")
        dispatchGroup = DispatchGroup()
        if isEditing {
            guard let manufacturer = manufacturer,
                  let nameImage = manufacturer.image else { return }
            let NameImageURL = URL(string: nameImage.replacingOccurrences(of: " ", with: ""))!
            let newNameFile = createNameImageFile(with: NameImageURL, for: enterManufacturer)
            enterManufacturer.image = newNameFile
            if manufacturer.name != enterManufacturer.name {
                setNameImage(oldName: nameImage, newName: newNameFile)
            } else if let newUrlFile = imageFileURL {
                setImage(with: newUrlFile, from: nameImage, to: newNameFile)
            }
            enterManufacturer.uid = manufacturer.uid
            setManufacturer(enterManufacturer)
        } else {
            guard let fileURL = imageFileURL else { return }
            let nameFile = createNameImageFile(with: fileURL, for: enterManufacturer)
            enterManufacturer.image = nameFile
            addImageToServer(with: fileURL, nameFile)
            addManufacturerToServer(enterManufacturer)
        }
        
        dispatchGroup.notify(queue: .main) {
            if self.receivedErrors.isEmpty {
                self.presenter.receivedSuccess(self.isEditing)
            } else {
                //TODO: исправить данный вывод ошибок
                for error in self.receivedErrors {
                    print(error)
                }
                let error = self.receivedErrors.last! as NSError
                self.presenter.receivedError(with: error.code, and: error.localizedDescription)
                self.receivedErrors.removeAll()
            }
        }
    }
    
    func didSelectImage(with urlFile: URL) {
        imageFileURL = urlFile
    }
    
    func receiveStartingDataView() {
        if isEditing {
            guard let manufacturer = manufacturer else { return }
            receiveImage(for: manufacturer)
            let pManufacturer = AddManufacturerEntity.Manufacturer(
                                    name: manufacturer.name,
                                    country: manufacturer.country,
                                    description: manufacturer.description)
            presenter.initialDataForPresentation(pManufacturer, isEditing: isEditing)
        } else {
            let pManufacturer = AddManufacturerEntity.Manufacturer(
                                    name: "",
                                    country: "",
                                    description: "")
            presenter.initialDataForPresentation(pManufacturer, isEditing: isEditing)
            presenter.initialImage(nil)
        }
    }
}

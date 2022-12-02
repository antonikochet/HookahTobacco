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
    func didEnterTobaccoLine(_ data: AddManufacturerEntity.TobaccoLine, index: Int?)
    func receiveEditingTobaccoLine(at index: Int)
}

protocol AddManufacturerInteractorOutputProtocol: AnyObject {
    func receivedSuccessAddition()
    func receivedSuccessEditing(with changedData: Manufacturer)
    func receivedError(with message: String)
    func initialDataForPresentation(_ manufacturer: AddManufacturerEntity.Manufacturer, isEditing: Bool)
    func initialImage(_ image: Data?)
    func initialTobaccoLines(_ lines: [TobaccoLine])
    func initialTobaccoLine(_ line: TobaccoLine)
}

class AddManufacturerInteractor {

    weak var presenter: AddManufacturerInteractorOutputProtocol!

    private var setNetworkManager: SetDataNetworkingServiceProtocol
    private var setImageManager: SetImageNetworkingServiceProtocol
    private var getImageManager: GetImageNetworkingServiceProtocol?

    private var imageFileURL: URL?
    private var manufacturer: Manufacturer?
    private var tobaccoLines: [TobaccoLine] = []
    private let isEditing: Bool
    private var editingImage: Data?

    private var dispatchGroup = DispatchGroup()
    private var receivedErrors: [Error] = []

    // init for add manufacturer
    init(setNetworkManager: SetDataNetworkingServiceProtocol,
         setImageManager: SetImageNetworkingServiceProtocol) {
        self.setNetworkManager = setNetworkManager
        self.setImageManager = setImageManager
        self.isEditing = false
    }

    // init for edit manufacturer
    init(_ manufacturer: Manufacturer,
         setNetworkManager: SetDataNetworkingServiceProtocol,
         setImageManager: SetImageNetworkingServiceProtocol,
         getImageManager: GetImageNetworkingServiceProtocol) {
        self.manufacturer = manufacturer
        self.setNetworkManager = setNetworkManager
        self.setImageManager = setImageManager
        self.getImageManager = getImageManager
        self.isEditing = true
        self.tobaccoLines = manufacturer.lines
    }

    // MARK: - methods for adding manufacturer data
    private func addImageToServer(with fileURL: URL, _ nameFile: String) {
        dispatchGroup.enter()
        setImageManager.addImage(by: fileURL,
                                 for: NamedFireStorage.manufacturerImage(name: nameFile)
        ) { [weak self] error in
            guard let self = self else { return }
            if let error = error { self.receivedErrors.append(error) }
            self.dispatchGroup.leave()
        }
    }

    private func addTobaccoLine(_ tobaccoLines: TobaccoLine, index: Int) {
        if tobaccoLines.uid.isEmpty {
            setNetworkManager.addTobaccoLine(tobaccoLines) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let uid):
                    var mtl = tobaccoLines
                    mtl.uid = uid
                    self.tobaccoLines[index] = mtl
                case .failure(let error):
                    self.presenter.receivedError(with: error.localizedDescription)
                }
            }
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
        } else if absolutePath.hasSuffix("png") {
            return "png"
        } else {
            // TODO: - придумать обход ошибки
           fatalError("Выбран неверный формат изображения для производителей")
        }
    }

    private func createNameImageFile(with fileURL: URL, for manufacturer: Manufacturer) -> String {
        let formatImage = extractingImageFormat(from: fileURL)
        return "\(manufacturer.name).\(formatImage)"
    }

    // MARK: - methods for changing manufacturer data
    private func receiveImage(for manufacturer: Manufacturer) {
        let nameImage = manufacturer.nameImage
        let type = NamedFireStorage.manufacturerImage(name: nameImage)
        getImageManager?.getImage(for: type) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.editingImage = image
                self.presenter.initialImage(image)
            case .failure(let error):
                self.presenter.receivedError(with: error.localizedDescription)
            }
        }
    }

    private func setNameImage(oldName: String, newName: String) {
        dispatchGroup.enter()
        setImageManager.setImageName(from: NamedFireStorage.manufacturerImage(name: oldName),
                                     to: NamedFireStorage.manufacturerImage(name: newName)) { [weak self] error in
            guard let self = self else { return }
            if let error = error { self.receivedErrors.append(error) }
            self.dispatchGroup.leave()
        }
    }

    private func setImage(with newURL: URL, from oldName: String, to newName: String) {
        dispatchGroup.enter()
        editingImage = try? Data(contentsOf: newURL)
        setImageManager.setImage(from: NamedFireStorage.manufacturerImage(name: oldName),
                                 to: newURL,
                                 for: NamedFireStorage.manufacturerImage(name: newName)) { [weak self] error in
            guard let self = self else { return }
            if let error = error { self.receivedErrors.append(error) }
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

    private func setTobaccoLine(_ tobaccoLines: TobaccoLine) {
        setNetworkManager.setTobaccoLine(tobaccoLines) { [weak self] error in
            guard let self = self else { return }
            if let error = error { self.presenter.receivedError(with: error.localizedDescription) }
        }
    }
}

extension AddManufacturerInteractor: AddManufacturerInteractorInputProtocol {
    func didEnterDataManufacturer(_ data: AddManufacturerEntity.Manufacturer) {
        guard !tobaccoLines.isEmpty else {
            presenter.receivedError(with: "У производителя должна быть хотя бы одна базовая линейка!")
            return
        }
        var enterManufacturer = Manufacturer(name: data.name,
                                             country: data.country,
                                             description: data.description ?? "",
                                             nameImage: "",
                                             link: data.link,
                                             lines: tobaccoLines)
        dispatchGroup = DispatchGroup()
        if isEditing {
            guard let manufacturer = manufacturer else { return }
            let nameImage = manufacturer.nameImage
            let NameImageURL = URL(string: nameImage.replacingOccurrences(of: " ", with: ""))!
            let newNameFile = createNameImageFile(with: NameImageURL, for: enterManufacturer)
            enterManufacturer.nameImage = newNameFile
            if let newURLFile = imageFileURL,
               manufacturer.name != enterManufacturer.name {
                setImage(with: newURLFile, from: nameImage, to: newNameFile)
            } else if manufacturer.name != enterManufacturer.name {
                setNameImage(oldName: nameImage, newName: newNameFile)
            } else if let newUrlFile = imageFileURL {
                setImage(with: newUrlFile, from: nameImage, to: newNameFile)
            }
            enterManufacturer.uid = manufacturer.uid
            setManufacturer(enterManufacturer)
        } else {
            guard let fileURL = imageFileURL else { return }
            let nameFile = createNameImageFile(with: fileURL, for: enterManufacturer)
            enterManufacturer.nameImage = nameFile
            addImageToServer(with: fileURL, nameFile)
            addManufacturerToServer(enterManufacturer)
        }

        dispatchGroup.notify(queue: .main) {
            if self.receivedErrors.isEmpty {
                if self.isEditing {
                    enterManufacturer.image = self.editingImage
                    self.presenter.receivedSuccessEditing(with: enterManufacturer)
                } else {
                    self.presenter.receivedSuccessAddition()
                }
            } else {
                // TODO: - исправить данный вывод ошибок
                for error in self.receivedErrors {
                    print(error)
                }
                let error = self.receivedErrors.last!
                self.presenter.receivedError(with: error.localizedDescription)
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
            if manufacturer.image == nil {
                receiveImage(for: manufacturer)
            } else {
                editingImage = manufacturer.image
                presenter.initialImage(manufacturer.image!)
            }
            let pManufacturer = AddManufacturerEntity.Manufacturer(
                                    name: manufacturer.name,
                                    country: manufacturer.country,
                                    description: manufacturer.description,
                                    link: manufacturer.link)
            presenter.initialDataForPresentation(pManufacturer, isEditing: isEditing)
        } else {
            let pManufacturer = AddManufacturerEntity.Manufacturer(
                                    name: "",
                                    country: "",
                                    description: "",
                                    link: "")
            presenter.initialDataForPresentation(pManufacturer, isEditing: isEditing)
            presenter.initialImage(nil)
        }
        presenter.initialTobaccoLines(tobaccoLines)
    }

    func didEnterTobaccoLine(_ data: AddManufacturerEntity.TobaccoLine, index: Int?) {
        if let index = index {
            let tobaccoLine = tobaccoLines[index]
            let newTobaccoLine = TobaccoLine(id: tobaccoLine.id,
                                             uid: tobaccoLine.uid,
                                             name: data.name,
                                             packetingFormat: data.packetingFormats,
                                             tobaccoType: TobaccoType(rawValue: data.selectedTobaccoTypeIndex)!,
                                             description: data.description,
                                             isBase: data.isBase)
            setTobaccoLine(newTobaccoLine)
            tobaccoLines[index] = newTobaccoLine
        } else {
            let tobaccoLine = TobaccoLine(name: data.name,
                                          packetingFormat: data.packetingFormats,
                                          tobaccoType: TobaccoType(rawValue: data.selectedTobaccoTypeIndex)!,
                                          description: data.description,
                                          isBase: data.isBase)
            tobaccoLines = []
            tobaccoLines.append(tobaccoLine)
            addTobaccoLine(tobaccoLine, index: tobaccoLines.count - 1)
        }
        presenter.initialTobaccoLines(tobaccoLines)
    }

    func receiveEditingTobaccoLine(at index: Int) {
        guard index < tobaccoLines.count else { return }
        presenter.initialTobaccoLine(tobaccoLines[index])
    }
}

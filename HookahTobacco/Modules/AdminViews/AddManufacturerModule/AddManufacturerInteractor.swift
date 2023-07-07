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

    private var setDataManager: AdminDataManagerProtocol
    private var getImageManager: GetImageNetworkingServiceProtocol?

    private var imageFileURL: URL?
    private var manufacturer: Manufacturer?
    private var tobaccoLines: [TobaccoLine] = []
    private let isEditing: Bool
    private var editingImage: Data?

    // init for add manufacturer
    init(setDataManager: AdminDataManagerProtocol) {
        self.setDataManager = setDataManager
        self.isEditing = false
    }

    // init for edit manufacturer
    init(_ manufacturer: Manufacturer,
         setDataManager: AdminDataManagerProtocol,
         getImageManager: GetImageNetworkingServiceProtocol) {
        self.manufacturer = manufacturer
        self.setDataManager = setDataManager
        self.getImageManager = getImageManager
        self.isEditing = true
        self.tobaccoLines = manufacturer.lines
    }

    // MARK: - methods for adding manufacturer data
    private func addTobaccoLine(_ tobaccoLines: TobaccoLine, index: Int) {
        if tobaccoLines.uid.isEmpty {
            setDataManager.addData(tobaccoLines) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let newTobaccoLine):
                    self.tobaccoLines[index] = newTobaccoLine
                case .failure(let error):
                    self.presenter.receivedError(with: error.localizedDescription)
                }
            }
        }
    }

    private func addManufacturerToServer(_ manufacturer: Manufacturer) {
        setDataManager.addData(manufacturer) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.presenter.receivedSuccessAddition()
            case .failure(let error):
                self.presenter.receivedError(with: error.localizedDescription)
            }
        }
    }

    // MARK: - methods for changing manufacturer data
    private func receiveImage(for manufacturer: Manufacturer) {
        getImageManager?.getImage(for: manufacturer.urlImage) { [weak self] result in
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

    private func setManufacturer(_ new: Manufacturer) {
        setDataManager.setData(new) { [weak self] error in
            guard let self = self else { return }
            if let error {
                self.presenter.receivedError(with: error.localizedDescription)
            } else {
                self.presenter.receivedSuccessEditing(with: new)
            }
        }
    }

    private func setTobaccoLine(_ tobaccoLines: TobaccoLine) {
        setDataManager.setData(tobaccoLines) { [weak self] error in
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
                                             urlImage: manufacturer?.urlImage ?? "",
                                             image: manufacturer?.image,
                                             link: data.link,
                                             lines: tobaccoLines)
        if isEditing {
            guard let manufacturer = manufacturer else { return }
            if let newURLFile = imageFileURL {
                if let image = try? Data(contentsOf: newURLFile) {
                    enterManufacturer.image = image
                    editingImage = image
                }
            }
            enterManufacturer.uid = manufacturer.uid
            setManufacturer(enterManufacturer)
        } else {
            guard let fileURL = imageFileURL else { return }
            if let image = try? Data(contentsOf: fileURL) {
                enterManufacturer.image = image
            }
            addManufacturerToServer(enterManufacturer)
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
        let tobaccoLeafTypes = (data.selectedTobaccoLeafTypeIndexs.isEmpty ? nil :
                                data.selectedTobaccoLeafTypeIndexs
                                    .compactMap { VarietyTobaccoLeaf(rawValue: $0) })
        if let index = index {
            let tobaccoLine = tobaccoLines[index]
            let newTobaccoLine = TobaccoLine(id: tobaccoLine.id,
                                             uid: tobaccoLine.uid,
                                             name: data.name,
                                             packetingFormat: data.packetingFormats,
                                             tobaccoType: TobaccoType(rawValue: data.selectedTobaccoTypeIndex)!,
                                             tobaccoLeafType: tobaccoLeafTypes,
                                             description: data.description,
                                             isBase: data.isBase)
            setTobaccoLine(newTobaccoLine)
            tobaccoLines[index] = newTobaccoLine
        } else {
            let tobaccoLine = TobaccoLine(name: data.name,
                                          packetingFormat: data.packetingFormats,
                                          tobaccoType: TobaccoType(rawValue: data.selectedTobaccoTypeIndex)!,
                                          tobaccoLeafType: tobaccoLeafTypes,
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

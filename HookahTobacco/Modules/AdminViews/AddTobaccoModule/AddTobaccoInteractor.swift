//
//
//  AddTobaccoInteractor.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import Foundation

protocol AddTobaccoInteractorInputProtocol: AnyObject {
    func sendNewTobaccoToServer(_ data: AddTobaccoEntity.Tobacco)
    func didSelectedManufacturer(_ name: String)
    func didSelectedTobaccoLine(_ name: String)
    func didSelectMainImage(with fileURL: URL)
    func receiveStartingDataView()
    func receiveTastesForEditing()
    func receivedNewSelectedTastes(_ tastes: [Taste])
}

protocol AddTobaccoInteractorOutputProtocol: PresenterrProtocol {
    func receivedSuccessAddition()
    func receivedSuccessEditing(with changedData: Tobacco)
    func receivedError(with message: String)
    func showNameManufacturersForSelect(_ names: [String])
    func showNameTobaccoLinesForSelect(_ names: [String])
    func initialDataForPresentation(_ tobacco: AddTobaccoEntity.Tobacco, isEditing: Bool)
    func initialSelectedManufacturer(_ name: String?)
    func initialSelectedTobaccoLine(_ name: String?)
    func initialMainImage(_ image: Data?)
    func initialTastes(_ tastes: [Taste])
    func receivedTastesForEditing(_ tastes: SelectedTastes)
}

class AddTobaccoInteractor {
    weak var presenter: AddTobaccoInteractorOutputProtocol!

    private var getDataManager: GetDataNetworkingServiceProtocol
    private var adminNetworkingService: AdminNetworkingServiceProtocol

    private var manufacturers: [Manufacturer]? {
        didSet {
            guard let manufacturers = manufacturers else { return }
            let names = manufacturers.map { $0.name }
            presenter.showNameManufacturersForSelect(names)
        }
    }
    private var selectedManufacturer: Manufacturer?
    private var selectedTobaccoLine: TobaccoLine?
    private var tobacco: Tobacco?
    private var tastes: SelectedTastes = [:]
    private var isEditing: Bool
    private var mainImageFileURL: URL?
    private var editingMainImage: Data?

    init(_ tobacco: Tobacco? = nil,
         getDataManager: GetDataNetworkingServiceProtocol,
         adminNetworkingService: AdminNetworkingServiceProtocol) {
        isEditing = tobacco != nil
        self.tobacco = tobacco
        self.selectedTobaccoLine = tobacco?.line
        self.getDataManager = getDataManager
        self.adminNetworkingService = adminNetworkingService
        getManufacturers()
    }

    private func getManufacturers() {
        getDataManager.receiveData(type: Manufacturer.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.manufacturers = data
                self.initialSelectedManufacturer()
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
    }

    private func addTobacco(_ tobacco: Tobacco, by imageFileURL: URL) {
        var tobaccoWithImage = tobacco
        if let image = try? Data(contentsOf: imageFileURL) {
            tobaccoWithImage.image = image
        }
        adminNetworkingService.addData(tobaccoWithImage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.presenter.receivedSuccessAddition()
                self.successAdded()
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
    }

    private func setTobacco(_ tobacco: Tobacco) {
        adminNetworkingService.setData(tobacco) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(var newTobacco):
                newTobacco.image = tobacco.image
                self.presenter.receivedSuccessEditing(with: newTobacco)
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
    }

    private func receiveSelectedManufacturer(by uid: Int) -> Manufacturer? {
        guard let manufacturers = manufacturers else { return nil }
        let manufacturer = manufacturers.first(where: { $0.uid == uid })
        return manufacturer
    }

    private func initialSelectedManufacturer() {
        guard let tobacco = tobacco,
              let manufacturer = receiveSelectedManufacturer(by: tobacco.idManufacturer) else { return }
        selectedManufacturer = manufacturer
        presenter.initialSelectedManufacturer(manufacturer.name)
        presenter.showNameTobaccoLinesForSelect(manufacturer.lines.map { $0.isBase ? "Базовая линейка" : $0.name })
        selectedTobaccoLine = tobacco.line
        presenter.initialSelectedTobaccoLine(selectedTobaccoLine.flatMap { $0.isBase ? "Базовая линейка" : $0.name })
        initialTastes()
    }

    private func initialTastes() {
        guard let tobacco = tobacco else { return }
        tastes = Dictionary(uniqueKeysWithValues: tobacco.tastes.map { ($0.uid, $0) })
        presenter.initialTastes(Array(tastes.values))
    }

    private func successAdded() {
        selectedManufacturer = nil
        selectedTobaccoLine = nil
        tobacco = nil
        tastes.removeAll()
        mainImageFileURL = nil
        editingMainImage = nil
    }
}

extension AddTobaccoInteractor: AddTobaccoInteractorInputProtocol {
    func sendNewTobaccoToServer(_ data: AddTobaccoEntity.Tobacco) {
        guard let selectManufacturer = selectedManufacturer,
              selectManufacturer.uid != -1 else {
            presenter.receivedError(with: "Не выбран производитель для табака!")
            return
        }
        guard let selectTobaccoLine = selectedTobaccoLine,
              selectTobaccoLine.uid != -1 else {
            presenter.receivedError(with: "Не выбрана линейка табака!")
            return
        }
        var tobacco = Tobacco(uid: tobacco?.uid ?? -1,
                              name: data.name,
                              tastes: Array(tastes.values),
                              idManufacturer: selectManufacturer.uid,
                              nameManufacturer: selectManufacturer.name,
                              description: data.description,
                              line: selectTobaccoLine,
                              imageURL: tobacco?.imageURL ?? "",
                              isFavorite: false,
                              isWantBuy: false,
                              image: tobacco?.image)
        if isEditing {
            if let mainImageFileURL {
                editingMainImage = try? Data(contentsOf: mainImageFileURL)
                tobacco.image = editingMainImage
                self.mainImageFileURL = nil
            }
            setTobacco(tobacco)
        } else {
            guard let imageFileURL = mainImageFileURL else {
                presenter.receivedError(with: "Изображение не было выбрано для табака!")
                return
            }
            addTobacco(tobacco, by: imageFileURL)
        }
    }

    func didSelectedManufacturer(_ name: String) {
        selectedManufacturer = manufacturers?.first(where: { name == $0.name })
        presenter.showNameTobaccoLinesForSelect(
            selectedManufacturer?.lines.map { $0.isBase ? "Базовая линейка" : $0.name } ?? []
        )
    }

    func didSelectedTobaccoLine(_ name: String) {
        selectedTobaccoLine = selectedManufacturer?.lines.first(where: {
            name == $0.name || ($0.isBase && name == "Базовая линейка")
        })
    }

    func didSelectMainImage(with fileURL: URL) {
        mainImageFileURL = fileURL
    }

    func receiveStartingDataView() {
        var pTobacco = AddTobaccoEntity.Tobacco(
                        name: "",
                        description: "")
        var manufacturer: Manufacturer?
        if isEditing,
           let tobacco = tobacco {
            pTobacco = AddTobaccoEntity.Tobacco(
                        name: tobacco.name,
                        description: tobacco.description)
            manufacturer = receiveSelectedManufacturer(by: tobacco.idManufacturer)
            if manufacturer != nil {
                selectedManufacturer = manufacturer
            }
            selectedTobaccoLine = tobacco.line
            editingMainImage = tobacco.image
        }
        presenter.initialDataForPresentation(pTobacco,
                                             isEditing: isEditing)
        presenter.initialSelectedManufacturer(manufacturer?.name)
        presenter.initialSelectedTobaccoLine(
            selectedTobaccoLine.flatMap { $0.isBase ? "Базовая линейка" : $0.name }
        )
        presenter.initialMainImage(editingMainImage)
    }

    func receiveTastesForEditing() {
        presenter.receivedTastesForEditing(tastes)
    }

    func receivedNewSelectedTastes(_ tastes: [Taste]) {
        self.tastes = Dictionary(uniqueKeysWithValues: tastes.map { ($0.uid, $0) })
        presenter.initialTastes(tastes)
    }
}

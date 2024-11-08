//
//
//  AddManufacturerInteractor.swift
//  HookahTobaccoAdmin
//
//  Created by антон кочетков on 07.10.2022.
//
//

import Foundation
import HookahTobaccoCore
import HookahTobaccoCoreAdmin

protocol AddManufacturerInteractorInputProtocol {
    func didEnterDataManufacturer(_ data: AddManufacturerEntity.Manufacturer)
    func didSelectImage(with urlFile: URL)
    func receiveStartingDataView()
    func receiveEditingTobaccoLine(at index: Int)
    func receivedTobaccoLine(_ tobaccoLine: TobaccoLine, for index: Int?)
    func didSelectCountry(_ name: String)
    var manufacturerId: Int? { get }
    func receivedCountriesAfterUpdate(_ newCountries: [Country])
}

protocol AddManufacturerInteractorOutputProtocol: PresenterrProtocol {
    func receivedSuccessAddition()
    func receivedSuccessEditing(with changedData: Manufacturer)
    func receivedError(with message: String)
    func initialDataForPresentation(_ manufacturer: AddManufacturerEntity.Manufacturer, isEditing: Bool)
    func initialImage(_ image: Data?)
    func initialTobaccoLines(_ lines: [TobaccoLine])
    func changeTobaccoLine(for id: Int, _ line: TobaccoLine)
    func initialCounties(_ countries: [Country])
    func showCountryForSelect(_ country: String?)
}

class AddManufacturerInteractor {

    weak var presenter: AddManufacturerInteractorOutputProtocol!

    private let countryRepo: CountryRepoProtocol
    private let manufacturerRepo: ManufacturerRepoProtocol
    private let adminManufacturerRepo: AdminManufacturerRepoProtocol
    private let getDataManager: DataManagerProtocol

    private var imageFileURL: URL?
    private var manufacturer: Manufacturer?
    private var countries: [Country] = []
    private var tobaccoLines: [TobaccoLine] = []
    private let isEditing: Bool
    private var editingImage: Data?
    private var selectedCountry: Country?

    // init for add manufacturer
    init(countryRepo: CountryRepoProtocol,
         getDataManager: DataManagerProtocol,
         manufacturerRepo: ManufacturerRepoProtocol,
         adminManufacturerRepo: AdminManufacturerRepoProtocol) {
        self.countryRepo = countryRepo
        self.getDataManager = getDataManager
        self.manufacturerRepo = manufacturerRepo
        self.adminManufacturerRepo = adminManufacturerRepo
        self.isEditing = false
        getCountries()
    }

    // init for edit manufacturer
    init(_ manufacturer: Manufacturer,
         countryRepo: CountryRepoProtocol,
         getDataManager: DataManagerProtocol,
         manufacturerRepo: ManufacturerRepoProtocol,
         adminManufacturerRepo: AdminManufacturerRepoProtocol) {
        self.manufacturer = manufacturer
        self.countryRepo = countryRepo
        self.getDataManager = getDataManager
        self.manufacturerRepo = manufacturerRepo
        self.adminManufacturerRepo = adminManufacturerRepo
        self.isEditing = true
        self.tobaccoLines = manufacturer.lines
        self.selectedCountry = manufacturer.country
        getCountries()
    }

    // MARK: - private methods
    private func getCountries() {
        countryRepo.fetchCountry { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let countries):
                self.countries = countries
                self.presenter.initialCounties(countries)
                if let manufacturer = self.manufacturer {
                    self.presenter.showCountryForSelect(manufacturer.country.name)
                }
            case .failure(let error):
                self.presenter.receivedError(HTError.createError(error))
            }
        }
    }

    // MARK: - methods for adding manufacturer data
    private func addManufacturerToServer(_ manufacturer: Manufacturer) {
        adminManufacturerRepo.create(manufacturer: manufacturer) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.presenter.receivedSuccessAddition()
            case .failure(let error):
                self.presenter.receivedError(HTError.createError(error))
            }
        }
    }

    // MARK: - methods for changing manufacturer data
    private func receiveImage(for manufacturer: Manufacturer) {
        getDataManager.receiveImage(for: manufacturer.urlImage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.editingImage = image
                self.presenter.initialImage(image)
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
    }

    private func setManufacturer(_ new: Manufacturer) {
        adminManufacturerRepo.update(manufacturer: new) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(var manufacturer):
                manufacturer.image = new.image
                self.presenter.receivedSuccessEditing(with: manufacturer)
            case .failure(let error):
                self.presenter.receivedError(HTError.createError(error))
            }
        }
    }
}

extension AddManufacturerInteractor: AddManufacturerInteractorInputProtocol {
    func didEnterDataManufacturer(_ data: AddManufacturerEntity.Manufacturer) {
        guard let selectedCountry else {
            presenter.receivedError(with: R.string.localizable.addManufacturerCountryEmptyMessage())
            return
        }
        
        if isEditing {
            guard let manufacturer = manufacturer else { return }
            var enterImage: Data?
            if let newURLFile = imageFileURL {
                if let image = try? Data(contentsOf: newURLFile) {
                    enterImage = image
                    editingImage = image
                }
            }
            let enterManufacturer = Manufacturer(
                id: manufacturer.id,
                name: data.name,
                country: selectedCountry,
                description: data.description ?? "",
                urlImage: imageFileURL?.absoluteString ?? manufacturer.urlImage,
                image: enterImage,
                link: data.link,
                lines: tobaccoLines
            )
            setManufacturer(enterManufacturer)
        } else {
            guard let fileURL = imageFileURL else { return }
            var enterManufacturer = Manufacturer(
                name: data.name,
                country: selectedCountry,
                description: data.description ?? "",
                urlImage: manufacturer?.urlImage ?? "",
                image: manufacturer?.image,
                link: data.link,
                lines: tobaccoLines)
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
                                    description: manufacturer.description,
                                    link: manufacturer.link)
            presenter.initialDataForPresentation(pManufacturer, isEditing: isEditing)
            presenter.showCountryForSelect(manufacturer.country.name)
        } else {
            let pManufacturer = AddManufacturerEntity.Manufacturer(
                                    name: "",
                                    description: "",
                                    link: "")
            presenter.initialDataForPresentation(pManufacturer, isEditing: isEditing)
            presenter.initialImage(nil)
            presenter.initialCounties(countries)
        }
        presenter.initialTobaccoLines(tobaccoLines)
    }

    func receiveEditingTobaccoLine(at index: Int) {
        guard index < tobaccoLines.count,
              let id = manufacturer?.id else { return }
        presenter.changeTobaccoLine(for: id, tobaccoLines[index])
    }

    func receivedTobaccoLine(_ tobaccoLine: TobaccoLine, for index: Int?) {
        if let index,
           index < tobaccoLines.count {
            tobaccoLines[index] = tobaccoLine
        } else {
            tobaccoLines.append(tobaccoLine)
        }
        presenter.initialTobaccoLines(tobaccoLines)
    }

    func didSelectCountry(_ name: String) {
        selectedCountry = countries.first(where: { $0.name == name })
        presenter.showCountryForSelect(selectedCountry?.name)
    }

    var manufacturerId: Int? {
        guard let strId = manufacturer?.id else {
            return nil
        }
        return Int(strId)
    }

    func receivedCountriesAfterUpdate(_ newCountries: [Country]) {
        if let selectedCountry {
            let id = selectedCountry.id
            if let newSelectedCountry = newCountries.first(where: { $0.id == id }) {
                self.selectedCountry = newSelectedCountry
            }
        }
        countries = newCountries
        presenter.initialCounties(countries)
        presenter.showCountryForSelect(selectedCountry?.name)
    }
}

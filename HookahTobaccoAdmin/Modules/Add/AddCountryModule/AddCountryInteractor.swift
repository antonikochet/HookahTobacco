//
//
//  AddCountryInteractor.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 06.08.2023.
//
//

import Foundation
import HookahTobaccoCore
import HookahTobaccoCoreAdmin

protocol AddCountryInteractorInputProtocol: AnyObject {
    func receiveStartingData()
    func addCountry(_ name: String)
    func editCountry(_ name: String, with uid: Int)
    func receiveCountries() -> [Country]
}

protocol AddCountryInteractorOutputProtocol: PresenterrProtocol {
    func receivedSuccessCountries(_ countries: [Country])
    func receivedError(with message: String)
    func receivedSuccessAddCountry(showWithNew countries: [Country])
}

class AddCountryInteractor {
    // MARK: - Public properties
    weak var presenter: AddCountryInteractorOutputProtocol!

    // MARK: - Dependency
    private let countryRepo: CountryRepoProtocol
    private let adminCountryRepo: AdminCountryRepoProtocol

    // MARK: - Private properties
    private var countries: [Country] = []

    // MARK: - Initializers
    init(countryRepo: CountryRepoProtocol,
         adminCountryRepo: AdminCountryRepoProtocol) {
        self.countryRepo = countryRepo
        self.adminCountryRepo = adminCountryRepo
    }

    // MARK: - Private methods
    private func receiveCountriesFromServer() {
        countryRepo.fetchCountry { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let counties):
                self.countries = counties
                self.presenter.receivedSuccessCountries(counties)
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
    }

    private func sendNewCountry(_ country: Country) {
        adminCountryRepo.create(country: country) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let newCountry):
                self.countries.append(newCountry)
                self.presenter.receivedSuccessAddCountry(showWithNew: self.countries)
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
    }

    private func sendEditCountry(_ country: Country, with index: Int) {
        adminCountryRepo.update(country: country) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let editCountry):
                self.countries[index] = editCountry
                self.presenter.receivedSuccessAddCountry(showWithNew: self.countries)
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
    }
}
// MARK: - InputProtocol implementation 
extension AddCountryInteractor: AddCountryInteractorInputProtocol {
    func receiveStartingData() {
        receiveCountriesFromServer()
    }

    func addCountry(_ name: String) {
        let newCountry = Country(name: name)
        sendNewCountry(newCountry)
    }

    func editCountry(_ name: String, with id: Int) {
        guard let index = countries.firstIndex(where: { $0.id == id }) else {
            presenter.receivedError(with: R.string.localizable.addCountryCountryErrorMessage("\(id)"))
            return
        }
        let country = countries[index]
        let editCountry = Country(id: country.id,
                                  name: name)
        sendEditCountry(editCountry, with: index)
    }

    func receiveCountries() -> [Country] {
        countries
    }
}

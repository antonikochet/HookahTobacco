//
//
//  AddCountryInteractor.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 06.08.2023.
//
//

import Foundation

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
    private let getDataManager: DataManagerProtocol
    private let adminNetworkingService: AdminNetworkingServiceProtocol

    // MARK: - Private properties
    private var countries: [Country] = []

    // MARK: - Initializers
    init(getDataManager: DataManagerProtocol,
         adminNetworkingService: AdminNetworkingServiceProtocol) {
        self.getDataManager = getDataManager
        self.adminNetworkingService = adminNetworkingService
    }

    // MARK: - Private methods
    private func receiveCountriesFromServer() {
        getDataManager.receiveData(typeData: Country.self) { [weak self] result in
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
        adminNetworkingService.addData(country) { [weak self] result in
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
        adminNetworkingService.setData(country) { [weak self] result in
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

    func editCountry(_ name: String, with uid: Int) {
        guard let index = countries.firstIndex(where: { $0.uid == uid }) else {
            presenter.receivedError(with: R.string.localizable.addCountryCountryErrorMessage("\(uid)"))
            return
        }
        let country = countries[index]
        let editCountry = Country(id: country.id,
                                  uid: country.uid,
                                  name: name)
        sendEditCountry(editCountry, with: index)
    }

    func receiveCountries() -> [Country] {
        countries
    }
}

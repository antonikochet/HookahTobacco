//
//
//  RegistrationInteractor.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.12.2022.
//
//

import Foundation

protocol RegistrationInteractorInputProtocol: AnyObject {
    func sendNewRegistrationData(email: String, pass: String)
}

protocol RegistrationInteractorOutputProtocol: AnyObject {
    func receivedSuccessRegistration()
    func receivedErrorRegistration(message: String)
}

final class RegistrationInteractor {
    // MARK: - Public properties
    weak var presenter: RegistrationInteractorOutputProtocol!

    // MARK: - Dependency
    private let registrationService: RegistrationServiceProtocol

    // MARK: - Private properties

    // MARK: - Initializers
    init(registrationService: RegistrationServiceProtocol) {
        self.registrationService = registrationService
    }

    // MARK: - Private methods

}
// MARK: - InputProtocol implementation 
extension RegistrationInteractor: RegistrationInteractorInputProtocol {
    func sendNewRegistrationData(email: String, pass: String) {
        registrationService.registration(email: email, password: pass) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.presenter.receivedErrorRegistration(message: error.localizedDescription)
                return
            }
            self.presenter.receivedSuccessRegistration()
        }
    }
}

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
    func sendCheckRegistrationData(username: String, email: String)
}

protocol RegistrationInteractorOutputProtocol: AnyObject {
    func receivedSuccessCheckRegistrationData()
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
    func sendCheckRegistrationData(username: String, email: String) {
        registrationService.checkRegistrationData(email: email, username: username) { [weak self] error in
            guard let self else { return }
            if let error {
                // TODO: переделат под показ ошибок под полями
                self.presenter.receivedErrorRegistration(message: error.localizedDescription)
                return
            }
            self.presenter.receivedSuccessCheckRegistrationData()
        }
    }
}

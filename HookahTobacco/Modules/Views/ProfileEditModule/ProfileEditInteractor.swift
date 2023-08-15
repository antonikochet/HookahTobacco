//
//
//  ProfileEditInteractor.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 13.08.2023.
//
//

import Foundation

protocol ProfileEditInteractorInputProtocol: AnyObject {
    func receiveStartData()
    func sendNewData(_ newUser: ProfileEditEntity.User)
}

protocol ProfileEditInteractorOutputProtocol: AnyObject {
    func receivedStartData(_ user: RegistrationUserProtocol, isRegistration: Bool)
    func receivedSuccessRegistration()
    func receivedSuccessEditProfile()
    func receivedError(with message: String)
}

class ProfileEditInteractor {
    // MARK: - Public properties
    weak var presenter: ProfileEditInteractorOutputProtocol!

    // MARK: - Dependency
    private let registrationService: RegistrationServiceProtocol

    // MARK: - Private properties
    private let isRegistration: Bool
    private var user: RegistrationUserProtocol

    // MARK: - Initializers
    init(isRegistration: Bool,
         user: RegistrationUserProtocol,
         registrationService: RegistrationServiceProtocol) {
        self.isRegistration = isRegistration
        self.user = user
        self.registrationService = registrationService
    }

    // MARK: - Private methods
    private func sendRegistrationData(_ newUser: RegistrationUserProtocol) {
        registrationService.registration(user: newUser) { [weak self] error in
            guard let self else { return }
            if let error {
                self.presenter.receivedError(with: error.localizedDescription)
                return
            }
            self.presenter.receivedSuccessRegistration()
        }
    }

    private func sendEditProfileData(_ editUser: RegistrationUserProtocol) {

    }
}
// MARK: - InputProtocol implementation 
extension ProfileEditInteractor: ProfileEditInteractorInputProtocol {
    func receiveStartData() {
        presenter.receivedStartData(user, isRegistration: isRegistration)
    }

    func sendNewData(_ newUser: ProfileEditEntity.User) {
        let user = RegistrationUser(
            username: user.username,
            email: user.email,
            password: user.password,
            repeatPassword: user.repeatPassword,
            firstName: newUser.firstName,
            lastName: newUser.lastName,
            dateOfBirth: newUser.dateOfBirth
        )
        if isRegistration {
            sendRegistrationData(user)
        } else {
            sendEditProfileData(user)
        }
    }
}

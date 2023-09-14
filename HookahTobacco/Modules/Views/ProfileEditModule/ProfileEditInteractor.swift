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

protocol ProfileEditInteractorOutputProtocol: PresenterrProtocol {
    func receivedStartData(_ user: RegistrationUserProtocol, isRegistration: Bool)
    func receivedSuccessRegistration()
    func receivedSuccessEditProfile(_ user: UserProtocol)
}

class ProfileEditInteractor {
    // MARK: - Public properties
    weak var presenter: ProfileEditInteractorOutputProtocol!

    // MARK: - Dependency
    private let registrationService: RegistrationServiceProtocol
    private let userNetworkingService: UserNetworkingServiceProtocol

    // MARK: - Private properties
    private let isRegistration: Bool
    private var user: RegistrationUserProtocol

    // MARK: - Initializers
    init(isRegistration: Bool,
         user: RegistrationUserProtocol,
         registrationService: RegistrationServiceProtocol,
         userNetworkingService: UserNetworkingServiceProtocol) {
        self.isRegistration = isRegistration
        self.user = user
        self.registrationService = registrationService
        self.userNetworkingService = userNetworkingService
    }

    // MARK: - Private methods
    private func sendRegistrationData(_ newUser: RegistrationUserProtocol) {
        registrationService.registration(user: newUser) { [weak self] error in
            guard let self else { return }
            if let error {
                self.presenter.receivedError(error)
                return
            }
            self.presenter.receivedSuccessRegistration()
        }
    }

    private func sendEditProfileData(_ editUser: RegistrationUserProtocol) {
        userNetworkingService.updateUser(editUser) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                self.presenter.receivedSuccessEditProfile(user)
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
    }
}
// MARK: - InputProtocol implementation 
extension ProfileEditInteractor: ProfileEditInteractorInputProtocol {
    func receiveStartData() {
        presenter.receivedStartData(user, isRegistration: isRegistration)
    }

    func sendNewData(_ newUser: ProfileEditEntity.User) {
        var user = RegistrationUser(
            username: isRegistration ? user.username : newUser.username,
            email: isRegistration ? user.email : newUser.email,
            password: user.password,
            repeatPassword: user.repeatPassword,
            firstName: newUser.firstName,
            lastName: newUser.lastName,
            dateOfBirth: newUser.dateOfBirth,
            gender: newUser.gender
        )
        user.isEdit = !isRegistration
        if isRegistration {
            user.isEditUsername = true
            sendRegistrationData(user)
        } else {
            user.isEditUsername = self.user.username != user.username
            sendEditProfileData(user)
        }
    }
}

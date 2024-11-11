//
//
//  ProfileEditInteractor.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 13.08.2023.
//
//

import Foundation
import HookahTobaccoCore

protocol ProfileEditInteractorInputProtocol: AnyObject {
    func receiveStartData()
    func sendNewData(_ newUser: ProfileEditEntity.User)
}

protocol ProfileEditInteractorOutputProtocol: PresenterrProtocol {
    func receivedStartData(_ user: RegistrationUser, isRegistration: Bool)
    func receivedSuccessRegistration()
    func receivedSuccessEditProfile(_ user: User)
    func receivedAgreementURLs(_ agreementURLs: [AgreementURLs])
}

class ProfileEditInteractor {
    // MARK: - Public properties
    weak var presenter: ProfileEditInteractorOutputProtocol!

    // MARK: - Dependency
    private let registrationService: RegistrationServiceProtocol
    private let userRepo: UserRepoProtocol

    // MARK: - Private properties
    private let isRegistration: Bool
    private var user: RegistrationUser

    // MARK: - Initializers
    init(isRegistration: Bool,
         user: RegistrationUser,
         registrationService: RegistrationServiceProtocol,
         userRepo: UserRepoProtocol) {
        self.isRegistration = isRegistration
        self.user = user
        self.registrationService = registrationService
        self.userRepo = userRepo
    }

    // MARK: - Private methods
    private func sendRegistrationData(_ newUser: RegistrationUser) {
        // TODO: - поправить
//        registrationService.registration(user: newUser) { [weak self] error in
//            guard let self else { return }
//            if let error {
//                self.presenter.receivedError(error)
//                return
//            }
//            self.presenter.receivedSuccessRegistration()
//        }
    }

    private func sendEditProfileData(_ editUser: RegistrationUser) {
        userRepo.updateUser(editUser) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                self.presenter.receivedSuccessEditProfile(user)
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
    }

    private func receiveAgreementURLs() {
        userRepo.fetchAgreementURLs(
            [.consentPersonalData, .userAgreement]
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                self.presenter.receivedAgreementURLs(response)
            case .failure:
                break
            }
        }
    }
}
// MARK: - InputProtocol implementation 
extension ProfileEditInteractor: ProfileEditInteractorInputProtocol {
    func receiveStartData() {
        receiveAgreementURLs()
        presenter.receivedStartData(user, isRegistration: isRegistration)
    }

    func sendNewData(_ newUser: ProfileEditEntity.User) {
        var user = RegistrationUser(
            username: isRegistration ? user.username : newUser.username,
            email: isRegistration ? user.email : newUser.email,
            password: user.password,
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

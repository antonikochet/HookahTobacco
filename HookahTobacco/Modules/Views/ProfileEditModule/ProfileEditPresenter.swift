//
//
//  ProfileEditPresenter.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 13.08.2023.
//
//

import Foundation

class ProfileEditPresenter {
    // MARK: - Public properties
    weak var view: ProfileEditViewInputProtocol!
    var interactor: ProfileEditInteractorInputProtocol!
    var router: ProfileEditRouterProtocol!

    // MARK: - Private properties
    private var dateOfBirth: Date?

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    // MARK: - Private methods
    private func updateDateOfBirth(_ newDate: Date?) {
        if let newDate {
            let strDate = dateFormatter.string(from: newDate)
            view.setupDateOfBirth(strDate)
        } else {
            view.setupDateOfBirth("")
        }
    }
}

// MARK: - InteractorOutputProtocol implementation
extension ProfileEditPresenter: ProfileEditInteractorOutputProtocol {
    func receivedStartData(_ user: RegistrationUserProtocol, isRegistration: Bool) {
        view.hideLoading()
        view.setupView(ProfileEditEntity.EnterData(
            firstName: user.firstName ?? "",
            lastName: user.lastName ?? ""
        ))
        updateDateOfBirth(user.dateOfBirth)
    }

    func receivedSuccessRegistration() {
        view.hideLoading()
        // TODO: добавить алерт/тост о том, что на почту было отправлено подтвержение почты
        router.showSuccess(delay: 1.5) { [weak self] in
            self?.router.showProfileView()
        }
    }

    func receivedSuccessEditProfile() {
        view.hideLoading()
        router.showSuccess(delay: 2.0) { [weak self] in
            self?.router.dismissEditProfileView()
        }
    }

    func receivedError(with message: String) {
        router.showError(with: message)
        view.hideLoading()
    }
}

// MARK: - ViewOutputProtocol implementation
extension ProfileEditPresenter: ProfileEditViewOutputProtocol {
    func viewDidLoad() {
        interactor.receiveStartData()
    }

    func pressedButton(_ entity: ProfileEditEntity.EnterData) {
        guard !entity.firstName.isEmpty else {
            router.showError(with: "Не ввели имя")
            return
        }
        guard !entity.lastName.isEmpty else {
            router.showError(with: "Не ввели фамилию")
            return
        }

        interactor.sendNewData(ProfileEditEntity.User(
            firstName: entity.firstName,
            lastName: entity.lastName,
            dateOfBirth: dateOfBirth
        ))
    }

    func pressedDateOfBirthTextField() {
        router.showDatePickerView(date: dateOfBirth,
                                  title: "День рождение",
                                  minDate: nil,
                                  maxDate: nil,
                                  delegate: self)
    }
}

extension ProfileEditPresenter: DatePickerOutputModule {
    func receivedNewDate(_ newDate: Date) {
        dateOfBirth = newDate
        updateDateOfBirth(dateOfBirth)
    }
}

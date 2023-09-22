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
    private var gender: Gender?
    private var isRegistration: Bool = false

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

    private func updateGender(_ newGender: Gender?) {
        if let newGender {
            view.setupGender(newGender.name)
        } else {
            view.setupGender("")
        }
    }
}

// MARK: - InteractorOutputProtocol implementation
extension ProfileEditPresenter: ProfileEditInteractorOutputProtocol {
    func receivedStartData(_ user: RegistrationUserProtocol, isRegistration: Bool) {
        view.hideLoading()
        self.isRegistration = isRegistration
        view.setupView(
            ProfileEditEntity.EnterData(
                firstName: user.firstName ?? "",
                lastName: user.lastName ?? "",
                username: user.username,
                email: user.email
            ),
            title: (isRegistration ?
                    R.string.localizable.profileEditTitleLabelTextRegistration() :
                        R.string.localizable.profileEditTitleLabelTextEdit()),
            buttonTitle: (isRegistration ?
                          R.string.localizable.profileEditButtonTitleRegistration() :
                            R.string.localizable.profileEditButtonTitleEdit()),
            isRegistration: isRegistration)
        dateOfBirth = user.dateOfBirth
        updateDateOfBirth(user.dateOfBirth)
        gender = user.gender
        updateGender(gender)
    }

    func receivedSuccessRegistration() {
        view.hideLoading()
        // TODO: добавить алерт/тост о том, что на почту было отправлено подтвержение почты
        router.showSuccess(delay: 1.5) { [weak self] in
            self?.router.showProfileView()
        }
    }

    func receivedSuccessEditProfile(_ user: UserProtocol) {
        view.hideLoading()
        router.showSuccess(delay: 1.0) { [weak self] in
            self?.router.dismissEditProfileView(user)
        }
    }

    func receivedAgreementURLs(_ agreementURLs: [AgreementURLsResponse]) {
        let text = R.string.localizable.profileEditAgreementTextViewText()
        let resultText = NSMutableAttributedString(string: text)
        for agreementURL in agreementURLs {
            guard let url = URL(string: agreementURL.url) else { continue }
            var range: NSRange?
            switch agreementURL.code {
            case .userAgreement:
                range = (text as NSString).range(of: R.string.localizable.profileEditUserAgreement())
            case .consentPersonalData:
                range = (text as NSString).range(of: R.string.localizable.profileEditPersonalData())
            }
            if let range {
                resultText.addAttribute(.link, value: url, range: range)
            }
        }
        view.setupAgreementTextView(resultText)
    }

    func receivedError(_ error: HTError) {
        view.hideLoading()
        if case let .apiError(apiErrors) = error {
            apiErrors.forEach { error in
                if error.fieldName == User.CodingKeys.username.rawValue {
                    view.showFieldError(error.message, field: .username)
                } else if error.fieldName == User.CodingKeys.email.rawValue {
                    view.showFieldError(error.message, field: .email)
                } else {
                    router.showError(with: error.message)
                }
            }
        } else {
            router.showError(with: error.message)
        }
    }
}

// MARK: - ViewOutputProtocol implementation
extension ProfileEditPresenter: ProfileEditViewOutputProtocol {
    func viewDidLoad() {
        interactor.receiveStartData()
    }

    func pressedButton(_ entity: ProfileEditEntity.EnterData) {
        var isError = false
        if entity.firstName.isEmpty {
            view.showFieldError(R.string.localizable.profileEditTextFieldEmptyErrorMessage(), field: .firstName)
            isError = true
        }
        if !isRegistration {
            if entity.username.isEmpty {
                view.showFieldError(R.string.localizable.profileEditTextFieldEmptyErrorMessage(), field: .username)
                isError = true
            }
            if entity.email.isEmpty {
                view.showFieldError(R.string.localizable.profileEditTextFieldEmptyErrorMessage(), field: .email)
                isError = true
            }
        }

        if isError {
            return
        }

        view.showBlockLoading()
        interactor.sendNewData(ProfileEditEntity.User(
            firstName: entity.firstName,
            lastName: entity.lastName,
            username: entity.username,
            email: entity.email,
            dateOfBirth: dateOfBirth,
            gender: gender
        ))
    }

    func pressedDateOfBirthTextField() {
        router.showDatePickerView(date: dateOfBirth,
                                  title: R.string.localizable.profileEditBottomSheetDateOfBirthTitle(),
                                  minDate: nil,
                                  maxDate: nil,
                                  delegate: self)
    }

    func pressedSexTextField() {
        router.showSexView(title: R.string.localizable.profileEditBottomSheetSexTitle(),
                           items: Gender.allCases.map { $0.name },
                           selectedIndex: gender?.rawValue,
                           output: self)
    }

    func pressedCloseButton() {
        router.dismissEditProfileView(nil)
    }

    func pressedAgreementText(_ url: URL) {
        router.showWebView(url)
    }
}

// MARK: - DatePickerOutputModule implementation
extension ProfileEditPresenter: DatePickerOutputModule {
    func receivedNewDate(_ newDate: Date) {
        dateOfBirth = newDate
        updateDateOfBirth(dateOfBirth)
    }
}

// MARK: - SelectListBottomSheetOutputModule implementation
extension ProfileEditPresenter: SelectListBottomSheetOutputModule {
    func receiveNewData(_ newIndex: Int?) {
        guard let newIndex else { return }
        gender = Gender(rawValue: newIndex)
        updateGender(gender)
    }
}

//
//
//  RegistrationViewController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.12.2022.
//
//

import UIKit
import SnapKit

protocol RegistrationViewInputProtocol: ViewProtocol {

}

protocol RegistrationViewOutputProtocol: AnyObject {
    func pressedRegistrationButton(username: String, email: String, pass: String, repeatPass: String)
}

final class RegistrationViewController: BaseViewController {
    // MARK: - Public properties
    var presenter: RegistrationViewOutputProtocol!

    // MARK: - UI properties
    private let registrationLabel = UILabel()
    private let usernameTextFieldView = AddTextFieldView()
    private let emailTextFieldView = AddTextFieldView()
    private let passTextFieldView = AddTextFieldView()
    private let repeatPassTextFieldView = AddTextFieldView()
    private let registrationButton = ApplyButton()

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewDidLayoutSubviews() {
        registrationButton.createCornerRadius()
    }

    // MARK: - Setups
    private func setupUI() {
        setupScreen()
        setupRegistrationLabel()
        setupUsername()
        setupEmail()
        setupPass()
        setupRepeatPass()
        setupRegistrationButton()
    }

    private func setupScreen() {
        view.backgroundColor = Colors.View.background
        overrideUserInterfaceStyle = .light
    }
    private func setupRegistrationLabel() {
        view.addSubview(registrationLabel)
        registrationLabel.font = Fonts.registrationLabel
        registrationLabel.textAlignment = .center
        registrationLabel.text = .registrationLabelText

        registrationLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(LayoutValues.RegistrationLabel.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Fonts.registrationLabel.lineHeight)
        }
    }
    private func setupUsername() {
        view.addSubview(usernameTextFieldView)
        usernameTextFieldView.setupView(textLabel: .usernameLabelText,
                                        placeholder: .usernamePlaceholder,
                                        delegate: self)
        usernameTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(registrationLabel.snp.bottom).offset(LayoutValues.Label.top)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.Label.horizPadding)
        }
    }
    private func setupEmail() {
        view.addSubview(emailTextFieldView)
        emailTextFieldView.setupView(textLabel: .emailLabelText,
                                     placeholder: .emailPlaceholder,
                                     delegate: self)
        emailTextFieldView.setKeyboardType(.emailAddress)
        emailTextFieldView.setTextContentType(.emailAddress)
        emailTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(usernameTextFieldView.snp.bottom).offset(LayoutValues.Label.top)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.Label.horizPadding)
        }
    }
    private func setupPass() {
        view.addSubview(passTextFieldView)
        passTextFieldView.setupView(textLabel: .passwordLabelText,
                                    placeholder: .passwordPlaceholder,
                                    delegate: self)
        passTextFieldView.setTextContentType(.password)
        passTextFieldView.setIsSecureTextEntry(true)
        passTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(emailTextFieldView.snp.bottom).offset(LayoutValues.Label.top)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.Label.horizPadding)
        }
    }
    private func setupRepeatPass() {
        view.addSubview(repeatPassTextFieldView)
        repeatPassTextFieldView.setupView(textLabel: .repeatPasswordLabelText,
                                          placeholder: .repeatPasswordPlaceholder,
                                          delegate: self)
        repeatPassTextFieldView.setTextContentType(.password)
        repeatPassTextFieldView.setIsSecureTextEntry(true)
        repeatPassTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(passTextFieldView.snp.bottom).offset(LayoutValues.Label.top)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.Label.horizPadding)
        }
    }
    private func setupRegistrationButton() {
        view.addSubview(registrationButton)
        registrationButton.setTitle(.registrationButtonText, for: .normal)
        registrationButton.action = { [weak self] in
            guard let self else { return }
            self.presenter.pressedRegistrationButton(
                username: self.usernameTextFieldView.text ?? "",
                email: self.emailTextFieldView.text ?? "",
                pass: self.passTextFieldView.text ?? "",
                repeatPass: self.repeatPassTextFieldView.text ?? ""
            )
        }
        registrationButton.titleLabel?.font = UIFont.appFont(size: 22, weight: .semibold)
        registrationButton.snp.makeConstraints { make in
            make.top.equalTo(repeatPassTextFieldView.snp.bottom).offset(LayoutValues.RegistrationButton.top)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.RegistrationButton.horizPadding)
            make.height.equalTo(LayoutValues.RegistrationButton.height)
        }
    }

    // MARK: - Private methods

    // MARK: - Selectors

}

// MARK: - ViewInputProtocol implementation
extension RegistrationViewController: RegistrationViewInputProtocol {

}

// MARK: - UITextFieldDelegate implementation
extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if usernameTextFieldView.isMyTextField(textField) {
            return emailTextFieldView.becomeFirstResponderTextField()
        } else if emailTextFieldView.isMyTextField(textField) {
            return passTextFieldView.becomeFirstResponderTextField()
        } else if passTextFieldView.isMyTextField(textField) {
            return repeatPassTextFieldView.becomeFirstResponderTextField()
        } else {
            return view.endEditing(true)
        }
    }
}

private extension String {
    static let registrationLabelText = "Регистрация"
    static let usernameLabelText = "Имя пользователя"
    static let usernamePlaceholder = "Введите пользователя"
    static let emailLabelText = "Email"
    static let emailPlaceholder = "Введите email"
    static let passwordLabelText = "Пароль"
    static let passwordPlaceholder = "password"
    static let repeatPasswordLabelText = "Повторите пароль"
    static let repeatPasswordPlaceholder = "Повторите пароль"
    static let registrationButtonText = "Продолжить регистрацию"
}
private struct LayoutValues {
    struct RegistrationLabel {
        static let top: CGFloat = 32.0
    }
    struct Label {
        static let top: CGFloat = 16.0
        static let horizPadding: CGFloat = 24.0
    }
    struct TextField {
        static let top: CGFloat = 4.0
        static let horizPadding: CGFloat = 24.0
    }
    struct RegistrationButton {
        static let top: CGFloat = 48.0
        static let height: CGFloat = 60.0
        static let horizPadding: CGFloat = 20.0
        static let cornerRadius: CGFloat = height / 2.0
    }
}
private struct Colors {
    struct View {
        static let background: UIColor = .white
    }
    struct TextField {
        static let text: UIColor = .black
        static let background: UIColor = UIColor(white: 0.95, alpha: 0.8)
    }
}
private struct Fonts {
    static let registrationButtonText = UIFont.appFont(size: 18, weight: .medium)
    static let registrationLabel = UIFont.appFont(size: 35, weight: .bold)
    static let label = UIFont.appFont(size: 16, weight: .regular)
}

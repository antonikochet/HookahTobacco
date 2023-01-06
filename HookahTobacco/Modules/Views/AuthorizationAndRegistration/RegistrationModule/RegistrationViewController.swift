//
//
//  RegistrationViewController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.12.2022.
//
//

import UIKit

protocol RegistrationViewInputProtocol: AnyObject {

}

protocol RegistrationViewOutputProtocol: AnyObject {
    func pressedRegistrationButton(email: String?, pass: String?, repeatPass: String?)
}

final class RegistrationViewController: UIViewController {
    // MARK: - Public properties
    var presenter: RegistrationViewOutputProtocol!

    // MARK: - UI properties
    private let registrationLabel = UILabel()
    private let emailLabel = UILabel()
    private let emailTextField = UITextField()
    private let passLabel = UILabel()
    private let passTextField = UITextField()
    private let repeatPassLabel = UILabel()
    private let repeatPassTextField = UITextField()
    private let registrationButton = UIButton.createAppBigButton(.registrationButtonText, fontSise: 25)

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillLayoutSubviews() {
        registrationButton.createCornerRadius()
    }

    // MARK: - Setups
    private func setupUI() {
        setupScreen()
        setupRegistrationLabel()
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
    private func setupEmail() {
        view.addSubview(emailLabel)
        emailLabel.font = Fonts.label
        emailLabel.text = .emailLabelText
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(registrationLabel.snp.bottom).offset(LayoutValues.Label.top)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.Label.horizPadding)
            make.height.equalTo(Fonts.label.lineHeight)
        }

        view.addSubview(emailTextField)
        emailTextField.placeholder = .emailPlaceholder
        emailTextField.textColor = Colors.TextField.text
        emailTextField.backgroundColor = Colors.TextField.background
        emailTextField.borderStyle = .roundedRect
        emailTextField.clearButtonMode = .whileEditing
        emailTextField.keyboardType = .emailAddress
        emailTextField.textContentType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(LayoutValues.TextField.top)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.TextField.horizPadding)
        }
    }
    private func setupPass() {
        view.addSubview(passLabel)
        passLabel.font = Fonts.label
        passLabel.text = .passwordLabelText
        passLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(LayoutValues.Label.top)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.Label.horizPadding)
            make.height.equalTo(Fonts.label.lineHeight)
        }

        view.addSubview(passTextField)
        passTextField.placeholder = .passwordPlaceholder
        passTextField.textColor = Colors.TextField.text
        passTextField.backgroundColor = Colors.TextField.background
        passTextField.borderStyle = .roundedRect
        passTextField.clearButtonMode = .whileEditing
        passTextField.textContentType = .password
        passTextField.autocapitalizationType = .none
        passTextField.isSecureTextEntry = true
        passTextField.snp.makeConstraints { make in
            make.top.equalTo(passLabel.snp.bottom).offset(LayoutValues.TextField.top)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.TextField.horizPadding)
        }
    }
    private func setupRepeatPass() {
        view.addSubview(repeatPassLabel)
        repeatPassLabel.font = Fonts.label
        repeatPassLabel.text = .repeatPasswordLabelText
        repeatPassLabel.snp.makeConstraints { make in
            make.top.equalTo(passTextField.snp.bottom).offset(LayoutValues.Label.top)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.Label.horizPadding)
            make.height.equalTo(Fonts.label.lineHeight)
        }

        view.addSubview(repeatPassTextField)
        repeatPassTextField.placeholder = .repeatPasswordPlaceholder
        repeatPassTextField.textColor = Colors.TextField.text
        repeatPassTextField.backgroundColor = Colors.TextField.background
        repeatPassTextField.borderStyle = .roundedRect
        repeatPassTextField.clearButtonMode = .whileEditing
        repeatPassTextField.textContentType = .password
        repeatPassTextField.autocapitalizationType = .none
        repeatPassTextField.isSecureTextEntry = true
        repeatPassTextField.snp.makeConstraints { make in
            make.top.equalTo(repeatPassLabel.snp.bottom).offset(LayoutValues.TextField.top)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.TextField.horizPadding)
        }
    }
    private func setupRegistrationButton() {
        view.addSubview(registrationButton)
        registrationButton.layer.cornerRadius = LayoutValues.RegistrationButton.cornerRadius
        registrationButton.addTarget(self, action: #selector(pressedRegistrationButton), for: .touchUpInside)
        registrationButton.snp.makeConstraints { make in
            make.top.equalTo(repeatPassTextField.snp.bottom).offset(LayoutValues.RegistrationButton.top)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.RegistrationButton.horizPadding)
            make.height.equalTo(LayoutValues.RegistrationButton.height)
        }
    }

    // MARK: - Private methods

    // MARK: - Selectors
    @objc private func pressedRegistrationButton() {
        presenter.pressedRegistrationButton(email: emailTextField.text,
                                            pass: passTextField.text,
                                            repeatPass: repeatPassTextField.text)
    }
}

// MARK: - ViewInputProtocol implementation
extension RegistrationViewController: RegistrationViewInputProtocol {

}

private extension String {
    static let registrationLabelText = "Регистрация"
    static let emailLabelText = "Email"
    static let emailPlaceholder = "Введите email"
    static let passwordLabelText = "Пароль"
    static let passwordPlaceholder = "password"
    static let repeatPasswordLabelText = "Повторите пароль"
    static let repeatPasswordPlaceholder = "Повторите пароль"
    static let registrationButtonText = "Зарегистрироваться"
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
        static let horizPadding: CGFloat = 40.0
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

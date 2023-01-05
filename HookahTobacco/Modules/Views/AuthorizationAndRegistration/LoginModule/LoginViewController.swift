//
//
//  LoginViewController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import UIKit
import SnapKit

protocol LoginViewInputProtocol: AnyObject {
}

protocol LoginViewOutputProtocol {
    func pressedButtonLogin(with login: String?, and password: String?)
    func pressedButtonRegistration()
}

class LoginViewController: UIViewController {
    // MARK: - Public properties
    var presenter: LoginViewOutputProtocol!

    // MARK: - UI properties
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton.createAppBigButton(.loginButtonText, fontSise: 25)
    private let registrationButton = UIButton()

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setups
    private func setupUI() {
        setupScreen()
        setupEmailTextField()
        setupPasswordTextField()
        setupLoginButton()
        setupRegistrationButton()
    }

    private func setupScreen() {
        title = .title
        view.backgroundColor = Colors.View.background
        overrideUserInterfaceStyle = .light
    }
    private func setupEmailTextField() {
        emailTextField.textColor = Colors.TextField.text
        emailTextField.borderStyle = .roundedRect
        emailTextField.clearButtonMode = .whileEditing
        emailTextField.keyboardType = .emailAddress
        emailTextField.placeholder = .emailPlaceholder
        emailTextField.textContentType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.backgroundColor = Colors.TextField.background
        emailTextField.delegate = self
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(LayoutValues.TextField.horizPadding)
            make.height.equalTo(LayoutValues.TextField.height)
        }
    }
    private func setupPasswordTextField() {
        passwordTextField.textColor = Colors.TextField.text
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.textContentType = .password
        passwordTextField.placeholder = .passwordPlaceholder
        passwordTextField.isSecureTextEntry = true
        passwordTextField.backgroundColor = Colors.TextField.background
        passwordTextField.delegate = self
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalTo(emailTextField.snp.bottom).offset(LayoutValues.TextField.top)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.TextField.horizPadding)
            make.height.equalTo(LayoutValues.TextField.height)
        }
    }
    private func setupLoginButton() {
        view.addSubview(loginButton)
        loginButton.layer.cornerRadius = LayoutValues.LoginButtom.cornerRadius
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(LayoutValues.LoginButtom.top)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.LoginButtom.horizPadding)
            make.height.equalTo(LayoutValues.LoginButtom.height)
        }
        loginButton.addTarget(self, action: #selector(touchLoginButton), for: .touchUpInside)
    }
    private func setupRegistrationButton() {
        registrationButton.setTitle(.registrationButtonText, for: .normal)
        registrationButton.setTitleColor(Colors.RegistrationButton.text, for: .normal)
        registrationButton.backgroundColor = Colors.RegistrationButton.background
        registrationButton.titleLabel?.font = Fonts.registrationButtonText

        view.addSubview(registrationButton)
        registrationButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(LayoutValues.RegistrationButton.top)
            make.centerX.equalToSuperview()
        }
        registrationButton.addTarget(self, action: #selector(touchRegistrationButton), for: .touchUpInside)
    }

    @objc private func touchLoginButton() {
        presenter.pressedButtonLogin(with: emailTextField.text, and: passwordTextField.text)
    }
    @objc private func touchRegistrationButton() {
        presenter.pressedButtonRegistration()
    }
}

extension LoginViewController: LoginViewInputProtocol {
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
            return true
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            return true
        }
        return false
    }
}

private extension String {
    static let loginButtonText = "Войти / Log in"
    static let title = "Log in"
    static let emailPlaceholder = "email"
    static let passwordPlaceholder = "password"
    static let registrationButtonText = "Регистрация"
}
private struct LayoutValues {
    struct TextField {
        static let top: CGFloat = 24.0
        static let horizPadding: CGFloat = 32.0
        static let height: CGFloat = 40.0
    }
    struct LoginButtom {
        static let top: CGFloat = 36.0
        static let horizPadding: CGFloat = 48.0
        static let height: CGFloat = 50.0
        static let cornerRadius: CGFloat = height / 2.0
    }
    struct RegistrationButton {
        static let top: CGFloat = 48.0
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
    struct RegistrationButton {
        static let text: UIColor = .systemBlue
        static let background: UIColor = .clear
    }
}
private struct Fonts {
    static let registrationButtonText = UIFont.appFont(size: 18, weight: .medium)
}

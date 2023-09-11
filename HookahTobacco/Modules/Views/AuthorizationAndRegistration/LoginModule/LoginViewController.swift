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

protocol LoginViewInputProtocol: ViewProtocol {
    func showEmailError(_ message: String)
    func showPasswordError(_ message: String)
}

protocol LoginViewOutputProtocol {
    func pressedButtonLogin(with login: String?, and password: String?)
    func pressedButtonRegistration()
}

class LoginViewController: BaseViewController {
    // MARK: - Public properties
    var presenter: LoginViewOutputProtocol!

    // MARK: - UI properties
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let emailTextField = TextFieldWithLeftLabel(rounding: .up, type: .text)
    private let passwordTextField = TextFieldWithLeftLabel(rounding: .down, type: .password)
    private let loginButton = ApplyButton(style: .primary)
    private let registrationButton = Button(style: .third)

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setups
    private func setupUI() {
        setupScreen()
        setupTitleLabel()
        setupSubtitleLabel()
        setupEmailTextField()
        setupPasswordTextField()
        setupLoginButton()
        setupRegistrationButton()
    }

    private func setupScreen() {
        view.backgroundColor = R.color.primaryBackground()
    }
    private func setupTitleLabel() {
        titleLabel.text = R.string.localizable.loginTitleText()
        titleLabel.font = UIFont.appFont(size: 30.0, weight: .bold)
        titleLabel.textColor = R.color.primaryTitle()
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24.0)
        }
    }
    private func setupSubtitleLabel() {
        subtitleLabel.text = R.string.localizable.loginSubtitleText()
        subtitleLabel.font = UIFont.appFont(size: 14.0, weight: .regular)
        subtitleLabel.textColor = R.color.primaryTitle()
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .left
        view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            make.leading.trailing.equalToSuperview().inset(24.0)
        }
    }
    private func setupEmailTextField() {
        emailTextField.setupView(title: R.string.localizable.loginEmailTextFieldTitle())
        emailTextField.didEndEditing = { [weak self] in
            if self?.emailTextField.text?.isEmpty ?? true {
                self?.emailTextField.setError(message: R.string.localizable.loginLoginErrorMessage())
            }
        }
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24.0)
            make.leading.trailing.equalToSuperview().inset(24.0)
        }
    }
    private func setupPasswordTextField() {
        passwordTextField.setupView(title: R.string.localizable.loginPasswordTextFieldTitle())
        passwordTextField.didEndEditing = { [weak self] in
            if self?.passwordTextField.text?.isEmpty ?? true {
                self?.passwordTextField.setError(message: R.string.localizable.loginPasswordErrorMessage())
            }
        }
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalTo(emailTextField.snp.bottom).offset(16.0)
            make.leading.trailing.equalToSuperview().inset(24.0)
        }
    }
    private func setupLoginButton() {
        loginButton.setTitle(R.string.localizable.loginLoginButtonTitle(), for: .normal)
        loginButton.action = { [weak self] in
            guard let self else { return }
            self.presenter.pressedButtonLogin(with: self.emailTextField.text,
                                              and: self.passwordTextField.text)
        }
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(36.0)
            make.leading.trailing.equalToSuperview().inset(45.0)
        }
    }
    private func setupRegistrationButton() {
        registrationButton.setTitle(R.string.localizable.loginRegistrationButtonTitle())
        registrationButton.action = { [weak self] in
            self?.presenter.pressedButtonRegistration()
        }

        view.addSubview(registrationButton)
        registrationButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(16.0)
            make.centerX.equalToSuperview()
        }
    }
}

extension LoginViewController: LoginViewInputProtocol {
    func showEmailError(_ message: String) {
        emailTextField.setError(message: message)
    }

    func showPasswordError(_ message: String) {
        passwordTextField.setError(message: message)
    }
}

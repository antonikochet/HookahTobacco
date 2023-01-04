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
    private let registrationButton = UIButton.createAppBigButton("Зарегистрироваться", fontSise: 25)

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
        setupRegistrationLabel()
        setupEmail()
        setupPass()
        setupRepeatPass()
        setupRegistrationButton()
    }

    private func setupRegistrationLabel() {
        view.addSubview(registrationLabel)
        registrationLabel.font = UIFont.appFont(size: 25, weight: .bold)
        registrationLabel.textAlignment = .center
        registrationLabel.text = "Регистрация"

        registrationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topSpacingFromSuperview)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(registrationLabel.font.lineHeight)
        }
    }

    private func setupEmail() {
        view.addSubview(emailLabel)
        emailLabel.font = UIFont.appFont(size: 14, weight: .regular)
        emailLabel.text = "Email"
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(registrationLabel.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
            make.height.equalTo(emailLabel.font.lineHeight)
        }

        view.addSubview(emailTextField)
        emailTextField.placeholder = "Введите email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.clearButtonMode = .whileEditing
        emailTextField.keyboardType = .emailAddress
        emailTextField.textContentType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }
    }

    private func setupPass() {
        view.addSubview(passLabel)
        passLabel.font = UIFont.appFont(size: 14, weight: .regular)
        passLabel.text = "Пароль"
        passLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
            make.height.equalTo(passLabel.font.lineHeight)
        }

        view.addSubview(passTextField)
        passTextField.placeholder = "Введите пароль"
        passTextField.borderStyle = .roundedRect
        passTextField.clearButtonMode = .whileEditing
        passTextField.textContentType = .password
        passTextField.autocapitalizationType = .none
        passTextField.isSecureTextEntry = true
        passTextField.snp.makeConstraints { make in
            make.top.equalTo(passLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }
    }

    private func setupRepeatPass() {
        view.addSubview(repeatPassLabel)
        repeatPassLabel.font = UIFont.appFont(size: 14, weight: .regular)
        repeatPassLabel.text = "Повторите пароль"
        repeatPassLabel.snp.makeConstraints { make in
            make.top.equalTo(passTextField.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
            make.height.equalTo(repeatPassLabel.font.lineHeight)
        }

        view.addSubview(repeatPassTextField)
        repeatPassTextField.placeholder = "Повторите пароль"
        repeatPassTextField.borderStyle = .roundedRect
        repeatPassTextField.clearButtonMode = .whileEditing
        repeatPassTextField.textContentType = .password
        repeatPassTextField.autocapitalizationType = .none
        repeatPassTextField.isSecureTextEntry = true
        repeatPassTextField.snp.makeConstraints { make in
            make.top.equalTo(repeatPassLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }
    }

    private func setupRegistrationButton() {
        view.addSubview(registrationLabel)
        registrationButton.addTarget(self, action: #selector(pressedRegistrationButton), for: .touchUpInside)
        registrationButton.snp.makeConstraints { make in
            make.top.equalTo(repeatPassTextField.snp.bottom).offset(topSpacingFromSuperview)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
            make.height.equalTo(60)
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

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

enum LoginField {
    case login
    case password
}

protocol LoginViewInputProtocol: AnyObject {
    func showAlertForUnspecifiedField(with title: String, message: String, error field: LoginField)
    func showAlertError(with message: String)
}

protocol LoginViewOutputProtocol {
    func pressedButtonLogin(with login: String?, and password: String?)
}

class LoginViewController: UIViewController {

    var presenter: LoginViewOutputProtocol!
    
    private let emailTextField: UITextField = {
        let text = UITextField()
        text.textColor = .black
        text.borderStyle = .roundedRect
        text.clearButtonMode = .whileEditing
        text.keyboardType = .emailAddress
        text.placeholder = "email"
        text.textContentType = .emailAddress
        text.autocapitalizationType = .none
        text.backgroundColor = UIColor(white: 0.95, alpha: 0.8)
        return text
    }()
    
    private let passwordTextField: UITextField = {
        let text = UITextField()
        text.textColor = .black
        text.borderStyle = .roundedRect
        text.clearButtonMode = .whileEditing
        text.textContentType = .password
        text.placeholder = "password"
        text.isSecureTextEntry = true
        text.backgroundColor = UIColor(white: 0.95, alpha: 0.8)
        return text
    }()
    
    private let loginButton: UIButton = UIButton.createAppBigButton("Войти / Log in", fontSise: 25)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log in"
        view.backgroundColor = .white
        overrideUserInterfaceStyle = .light
        setupSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        loginButton.clipsToBounds = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    private func setupSubviews() {
        view.addSubview(emailTextField)
        emailTextField.delegate = self
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(56)
            make.leading.trailing.equalTo(view).inset(32)
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.delegate = self
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(24)
            make.leading.trailing.equalTo(view).inset(32)
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(32)
            make.leading.trailing.equalTo(view).inset(48)
            make.height.equalTo(60)
        }
        loginButton.addTarget(self, action: #selector(touchLoginButton), for: .touchUpInside)
    }
    
    @objc
    private func touchLoginButton() {
        presenter.pressedButtonLogin(with: emailTextField.text, and: passwordTextField.text)
    }
}

extension LoginViewController: LoginViewInputProtocol {
    func showAlertForUnspecifiedField(with title: String, message: String, error field: LoginField) {
        showAlertError(title: title, message: message) {
            switch field {
                case .login:
                    self.emailTextField.becomeFirstResponder()
                case .password:
                    self.passwordTextField.becomeFirstResponder()
            }
        }
    }
    
    func showAlertError(with message: String) {
        showAlertError(title: "Ошибка", message: message)
    }
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

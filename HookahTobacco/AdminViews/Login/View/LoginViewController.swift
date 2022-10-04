//
//  LoginViewController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 16.09.2022.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
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

    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти / Log in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.8
        button.titleLabel?.font = UIFont.appFont(size: 25, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log in"
        view.backgroundColor = .white
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
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlertError(title: "Ошибка", message: "email не введен") {
                self.emailTextField.becomeFirstResponder()
            }
            return
        }
        guard let pass = passwordTextField.text, !pass.isEmpty else {
            showAlertError(title: "Ошибка", message: "пароль не введен") {
                self.passwordTextField.becomeFirstResponder()
            }
            return
        }
        
        FireBaseAuthService.shared.login(with: email, password: pass) { [weak self] error in
            if let error = error {
                self?.showAlertError(title: "Ошибка", message: "Ошибка: \((error as NSError).userInfo)") //TODO: написать пользовательские ошибки
            } else {
                let addedMenuVC = AddedMenuViewController()
                self?.navigationController?.setViewControllers([addedMenuVC], animated: true)
                //router to view
            }
        }
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

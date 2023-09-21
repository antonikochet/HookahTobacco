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

enum RegistrationInputFields {
    case username
    case email
    case password
    case repearPassword
}

protocol RegistrationViewInputProtocol: ViewProtocol {
    func showFieldError(_ message: String?, field: RegistrationInputFields)
}

protocol RegistrationViewOutputProtocol: AnyObject {
    func pressedRegistrationButton(username: String, email: String, pass: String, repeatPass: String)
}

final class RegistrationViewController: HTScrollContentViewController {
    // MARK: - Public properties
    var presenter: RegistrationViewOutputProtocol!

    override var stackViewInset: UIEdgeInsets {
        UIEdgeInsets(horizontal: 24, vertical: 0)
    }

    // MARK: - UI properties
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let usernameTextFieldView = TextFieldWithLeftLabel(rounding: .up, type: .text)
    private let emailTextFieldView = TextFieldWithLeftLabel(rounding: .down, type: .email)
    private let passTextFieldView = TextFieldWithLeftLabel(rounding: .up, type: .password)
    private let repeatPassTextFieldView = TextFieldWithLeftLabel(rounding: .down, type: .password)
    private let continueButton = ApplyButton(style: .primary)

    // MARK: - Private properties
    private var offsetStackView: CGPoint = .zero

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: - Setups
    private func setupUI() {
        setupSubviews()
        setupScreen()
        setupTitleLabel()
        setupSubtitleLabel()
        setupUsername()
        setupEmail()
        setupPass()
        setupRepeatPass()
        setupRegistrationButton()
        setupConstrainsScrollView(top: view.safeAreaLayoutGuide.snp.top, topConstant: 48)
    }

    private func setupScreen() {
        view.backgroundColor = R.color.primaryBackground()
        stackView.spacing = 24.0
        stackView.distribution = .fill
    }
    private func setupTitleLabel() {
        titleLabel.text = R.string.localizable.registrationTitleLabelText()
        titleLabel.font = UIFont.appFont(size: 30.0, weight: .bold)
        titleLabel.textColor = R.color.primaryTitle()
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left
        stackView.addArrangedSubview(titleLabel)
    }
    private func setupSubtitleLabel() {
        subtitleLabel.text = R.string.localizable.registrationSubtitleLabelText()
        subtitleLabel.font = UIFont.appFont(size: 16.0, weight: .regular)
        subtitleLabel.textColor = R.color.primaryTitle()
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .left
        stackView.addArrangedSubview(subtitleLabel)
        stackView.setCustomSpacing(8.0, after: titleLabel)
    }
    private func setupUsername() {
        let fieldOffset = CGPoint.zero
        usernameTextFieldView.setupView(title: R.string.localizable.registrationUsernameTitle())
        usernameTextFieldView.didEndEditing = { [weak self] in
            guard let self else { return }
            self.textFieldDidEndEditingAction(self.usernameTextFieldView)
        }
        usernameTextFieldView.didBeginEditing = { [weak self] in
            self?.setOffset(fieldOffset)
            self?.offsetStackView = .zero
        }
        usernameTextFieldView.shouldBeginEditing = { [weak self] in
            self?.offsetStackView = fieldOffset
            return true
        }
        stackView.addArrangedSubview(usernameTextFieldView)
    }
    private func setupEmail() {
        let fieldOffset = CGPoint.zero
        emailTextFieldView.setupView(title: R.string.localizable.registrationEmailTitle())
        emailTextFieldView.didEndEditing = { [weak self] in
            guard let self else { return }
            self.textFieldDidEndEditingAction(self.emailTextFieldView)
        }
        emailTextFieldView.didBeginEditing = { [weak self] in
            self?.setOffset(fieldOffset)
            self?.offsetStackView = .zero
        }
        emailTextFieldView.shouldBeginEditing = { [weak self] in
            self?.offsetStackView = fieldOffset
            return true
        }
        stackView.addArrangedSubview(emailTextFieldView)
        stackView.setCustomSpacing(12.0, after: usernameTextFieldView)
    }
    private func setupPass() {
        let fieldOffset = CGPoint(x: 0, y: 50)
        passTextFieldView.setupView(title: R.string.localizable.registrationPasswordTitle())
        passTextFieldView.didEndEditing = { [weak self] in
            guard let self else { return }
            self.textFieldDidEndEditingAction(self.passTextFieldView)
        }
        passTextFieldView.shouldBeginEditing = { [weak self] in
            self?.offsetStackView = fieldOffset
            return true
        }
        passTextFieldView.didBeginEditing = { [weak self] in
            self?.setOffset(fieldOffset)
            self?.offsetStackView = .zero
        }
        stackView.addArrangedSubview(passTextFieldView)
    }
    private func setupRepeatPass() {
        let fieldOffset = CGPoint(x: 0, y: 100)
        repeatPassTextFieldView.setupView(title: R.string.localizable.registrationRepeatPasswordTitle())
        repeatPassTextFieldView.didEndEditing = { [weak self] in
            guard let self else { return }
            self.textFieldDidEndEditingAction(self.repeatPassTextFieldView)
        }
        repeatPassTextFieldView.shouldBeginEditing = { [weak self] in
            self?.offsetStackView = fieldOffset
            return true
        }
        repeatPassTextFieldView.didBeginEditing = { [weak self] in
            self?.setOffset(fieldOffset)
            self?.offsetStackView = .zero
        }
        stackView.addArrangedSubview(repeatPassTextFieldView)
        stackView.setCustomSpacing(12.0, after: passTextFieldView)
    }
    private func setupRegistrationButton() {
        continueButton.setTitle(R.string.localizable.registrationContinueButtonTitle(), for: .normal)
        continueButton.action = { [weak self] in
            guard let self else { return }
            self.presenter.pressedRegistrationButton(
                username: self.usernameTextFieldView.text ?? "",
                email: self.emailTextFieldView.text ?? "",
                pass: self.passTextFieldView.text ?? "",
                repeatPass: self.repeatPassTextFieldView.text ?? ""
            )
        }
        stackView.addArrangedSubview(continueButton)
        stackView.setCustomSpacing(36.0, after: repeatPassTextFieldView)
    }

    // MARK: - Private methods
    private func textFieldDidEndEditingAction(_ textField: TextFieldWithLeftLabel) {
        setOffset(offsetStackView)
        if textField.text?.isEmpty ?? true {
            textField.setError(message: R.string.localizable.registrationTextFieldEmptyErrorMessage())
        }
    }

    // MARK: - Selectors

}

// MARK: - ViewInputProtocol implementation
extension RegistrationViewController: RegistrationViewInputProtocol {
    func showFieldError(_ message: String?, field: RegistrationInputFields) {
        switch field {
        case .username:
            usernameTextFieldView.setError(message: message)
        case .email:
            emailTextFieldView.setError(message: message)
        case .password:
            passTextFieldView.setError(message: message)
        case .repearPassword:
            repeatPassTextFieldView.setError(message: message)
        }
    }
}

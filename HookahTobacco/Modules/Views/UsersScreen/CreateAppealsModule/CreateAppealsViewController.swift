//
//
//  CreateAppealsViewController.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 17.09.2023.
//
//

import UIKit
import SnapKit

enum CreateAppealsInputType {
    case name
    case email
    case theme
    case message
}

protocol CreateAppealsViewInputProtocol: ViewProtocol {
    func setupView(_ viewModel: CreateAppealsEntity.ViewModel)
    func setupThemeView(_ text: String)
    func showError(_ message: String, field: CreateAppealsInputType)
}

protocol CreateAppealsViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func pressedThemeView()
    func pressedSendButton(_ enterData: CreateAppealsEntity.EnterData)
}

class CreateAppealsViewController: HTScrollContentViewController {
    // MARK: - Public properties
    var presenter: CreateAppealsViewOutputProtocol!

    override var stackViewInset: UIEdgeInsets {
        UIEdgeInsets(horizontal: 24.0, vertical: 0.0)
    }

    // MARK: - UI properties
    private let titleLabel = UILabel()
    private let nameTextFieldView = AddTextFieldView()
    private let emailTextFieldView = AddTextFieldView()
    private let themeTextFieldView = AddTextFieldView()
    private let messageTextView = AddTextView()
    // contents
    private let sendButton = ApplyButton(style: .primary)

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter.viewDidLoad()
    }

    // MARK: - Setups
    private func setupUI() {
        setupSubviews()
        setupScreen()
        setupTitleLabel()
        setupNameTextFieldView()
        setupEmailTextFieldView()
        setupThemeTextFieldView()
        setupMessageTextView()
        setupContentsView()
        setupSendButton()
        setupConstrainsScrollView(top: view.safeAreaLayoutGuide.snp.top, topConstant: 32.0,
                                  bottom: sendButton.snp.top, bottomConstant: 24.0)
    }
    private func setupScreen() {
        view.backgroundColor = R.color.primaryBackground()
        stackView.spacing = 16.0
        navigationItem.title = R.string.localizable.createAppealsTitle()
    }
    private func setupTitleLabel() {
        titleLabel.text = R.string.localizable.createAppealsTitleLabelText()
        titleLabel.font = UIFont.appFont(size: 30.0, weight: .bold)
        titleLabel.textColor = R.color.primaryTitle()
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left
        stackView.addArrangedSubview(titleLabel)
    }
    private func setupNameTextFieldView() {
        stackView.addArrangedSubview(nameTextFieldView)
        nameTextFieldView.setupView(textLabel: R.string.localizable.createAppealsNameTitle(),
                           placeholder: R.string.localizable.createAppealsNamePlaceholder(),
                           delegate: self)
    }
    private func setupEmailTextFieldView() {
        stackView.addArrangedSubview(emailTextFieldView)
        emailTextFieldView.setupView(textLabel: R.string.localizable.createAppealsEmailTitle(),
                           placeholder: R.string.localizable.createAppealsEmailPlaceholder(),
                           delegate: self)
    }
    private func setupThemeTextFieldView() {
        stackView.addArrangedSubview(themeTextFieldView)
        themeTextFieldView.setTextAlignmentTextField(.center)
        themeTextFieldView.setupView(textLabel: R.string.localizable.createAppealsThemeTitle(),
                           placeholder: "",
                           delegate: self)
    }
    private func setupMessageTextView() {
        stackView.addArrangedSubview(messageTextView)
        messageTextView.heightTextView = 120
        messageTextView.setupView(textLabel: R.string.localizable.createAppealsMessageTitle(), delegate: self)
    }
    private func setupContentsView() {

    }
    private func setupSendButton() {
        sendButton.setTitle(R.string.localizable.createAppealsSendButtonTitle(), for: .normal)
        sendButton.action = { [weak self] in
            guard let self else { return }
            self.presenter.pressedSendButton(
                CreateAppealsEntity.EnterData(
                    name: self.nameTextFieldView.text ?? "",
                    email: self.emailTextFieldView.text ?? "",
                    message: self.messageTextView.text
                ))
        }
        view.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(32.0)
            make.centerX.equalToSuperview()
        }
    }
    // MARK: - Private methods

    // MARK: - Selectors

}

// MARK: - ViewInputProtocol implementation
extension CreateAppealsViewController: CreateAppealsViewInputProtocol {
    func setupView(_ viewModel: CreateAppealsEntity.ViewModel) {
        nameTextFieldView.text = viewModel.name
        emailTextFieldView.text = viewModel.email
    }

    func setupThemeView(_ text: String) {
        themeTextFieldView.text = text
    }

    func showError(_ message: String, field: CreateAppealsInputType) {
        switch field {
        case .name:
            nameTextFieldView.setError(message: message)
        case .email:
            emailTextFieldView.setError(message: message)
        case .theme:
            themeTextFieldView.setError(message: message)
        case .message:
            break
//            messageTextView.setError(message: message)
        }
    }
}

// MARK: - UITextFieldDelegate implementation
extension CreateAppealsViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if themeTextFieldView.isMyTextField(textField) {
            presenter.pressedThemeView()
            themeTextFieldView.setError(message: nil)
            return false
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let textFields = [nameTextFieldView, emailTextFieldView]
        for field in textFields where field.isMyTextField(textField) {
            field.setError(message: nil)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            let textFields = [nameTextFieldView, emailTextFieldView, themeTextFieldView]
            for field in textFields where field.isMyTextField(textField) {
                field.setError(message: R.string.localizable.createAppealsTextFieldEmptyErrorMessage())
            }
        }
    }
}

// MARK: - UITextFieldDelegate implementation
extension CreateAppealsViewController: UITextViewDelegate {

}

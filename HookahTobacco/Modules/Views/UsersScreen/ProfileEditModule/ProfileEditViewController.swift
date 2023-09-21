//
//
//  ProfileEditViewController.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 13.08.2023.
//
//

import UIKit
import FittedSheets
import SnapKit

enum ProfileEditInputFields {
    case firstName
    case username
    case email
}

protocol ProfileEditViewInputProtocol: ViewProtocol {
    func setupView(_ data: ProfileEditEntity.EnterData, title: String, buttonTitle: String, isRegistration: Bool)
    func setupDateOfBirth(_ date: String)
    func setupGender(_ gender: String)
    func showFieldError(_ message: String, field: ProfileEditInputFields)
}

protocol ProfileEditViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func pressedButton(_ entity: ProfileEditEntity.EnterData)
    func pressedDateOfBirthTextField()
    func pressedSexTextField()
    func pressedCloseButton()
}

class ProfileEditViewController: HTScrollContentViewController, BottomSheetPresenter {
    // MARK: - BottomSheetPresenter
    var sizes: [SheetSize] = [.marginFromTop(50)]
    var isShowGrip: Bool = false

    // MARK: - Public properties
    var presenter: ProfileEditViewOutputProtocol!

    override var stackViewInset: UIEdgeInsets {
        UIEdgeInsets(horizontal: 24, vertical: 0)
    }

    // MARK: - UI properties
    // TODO: добавить email, username при режиме редактирования
    private let closeView = UIView()
    private let closeButton = IconButton()
    private let titleLabel = UILabel()
    private let firstNameFieldView = TextFieldWithLeftLabel(rounding: .up, type: .text)
    private let lastNameFieldView = TextFieldWithLeftLabel(rounding: .down, type: .text)
    private let usernameTextFieldView = TextFieldWithLeftLabel(rounding: .up, type: .text)
    private let emailTextFieldView = TextFieldWithLeftLabel(rounding: .down, type: .email)
    private let dateOfBirthFieldView = TextFieldWithLeftLabel(rounding: .up, type: .text)
    private let sexFieldView = TextFieldWithLeftLabel(rounding: .down, type: .text)
    private let agreementView = UIView()
    private let agreementTextView = UITextView()
    private let agreementSwitch = UISwitch()
    private let button = ApplyButton(style: .primary)

    // MARK: - Private properties
    private var offsetStackView: CGPoint = .zero

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter.viewDidLoad()
    }

    // MARK: - Setups
    private func setupUI() {
        setupSubviews()
        setupView()
        setupCloseButton()
        setupTitleLabel()
        setupFirstNameFieldView()
        setupLastNameFieldView()
        setupUsername()
        setupEmail()
        setupDateOfBirthFieldView()
        setupSexFieldView()
        setupAgreementSwitchView()
        setupButton()
        setupConstrainsScrollView(top: view.safeAreaLayoutGuide.snp.top,
                                  bottom: view.safeAreaLayoutGuide.snp.bottom)
    }
    private func setupView() {
        view.backgroundColor = R.color.primaryBackground()
        stackView.spacing = 12
    }
    private func setupCloseButton() {
        closeButton.image = R.image.close()
        closeButton.size = 36.0
        closeButton.imageSize = 36.0
        closeButton.action = { [weak self] in
            self?.presenter.pressedCloseButton()
        }
        closeView.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8.0)
            make.trailing.equalToSuperview()
        }
        stackView.addArrangedSubview(closeView)
    }
    private func setupTitleLabel() {
        titleLabel.font = UIFont.appFont(size: 30.0, weight: .bold)
        titleLabel.textColor = R.color.primaryTitle()
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left
        stackView.addArrangedSubview(titleLabel)
    }
    private func setupFirstNameFieldView() {
        let fieldOffset = CGPoint.zero
        firstNameFieldView.setupView(title: R.string.localizable.profileEditFirstNameTitle())
        firstNameFieldView.didEndEditing = { [weak self] in
            guard let self else { return }
            self.textFieldDidEndEditingAction(self.firstNameFieldView)
        }
        firstNameFieldView.didBeginEditing = { [weak self] in
            self?.setOffset(fieldOffset)
            self?.offsetStackView = .zero
        }
        firstNameFieldView.shouldBeginEditing = { [weak self] in
            self?.offsetStackView = fieldOffset
            return true
        }
        stackView.addArrangedSubview(firstNameFieldView)
        stackView.setCustomSpacing(36, after: titleLabel)
    }
    private func setupLastNameFieldView() {
        let fieldOffset = CGPoint.zero
        lastNameFieldView.setupView(title: R.string.localizable.profileEditLastNameTitle())
        lastNameFieldView.didEndEditing = { [weak self] in
            guard let self else { return }
            self.textFieldDidEndEditingAction(self.lastNameFieldView, isRequired: false)
        }
        lastNameFieldView.didBeginEditing = { [weak self] in
            self?.setOffset(fieldOffset)
            self?.offsetStackView = .zero
        }
        lastNameFieldView.shouldBeginEditing = { [weak self] in
            self?.offsetStackView = fieldOffset
            return true
        }
        stackView.addArrangedSubview(lastNameFieldView)
    }
    private func setupUsername() {
        let fieldOffset = CGPoint(x: 0, y: 30)
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
        stackView.setCustomSpacing(24.0, after: lastNameFieldView)
    }
    private func setupEmail() {
        let fieldOffset = CGPoint(x: 0, y: 60)
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
    }
    private func setupDateOfBirthFieldView() {
        dateOfBirthFieldView.setupView(title: R.string.localizable.profileEditDateOfBirthTitle())
        dateOfBirthFieldView.didBeginEditing = { [weak self] in
            self?.view.endEditing(true)
            self?.setOffset(.zero)
            self?.offsetStackView = .zero
            self?.presenter.pressedDateOfBirthTextField()
        }
        stackView.addArrangedSubview(dateOfBirthFieldView)
        stackView.setCustomSpacing(24, after: emailTextFieldView)
    }
    private func setupSexFieldView() {
        sexFieldView.setupView(title: R.string.localizable.profileEditSexTitle())
        sexFieldView.didBeginEditing = { [weak self] in
            self?.view.endEditing(true)
            self?.setOffset(.zero)
            self?.offsetStackView = .zero
            self?.presenter.pressedSexTextField()
        }
        stackView.addArrangedSubview(sexFieldView)
    }
    private func setupAgreementSwitchView() {
        agreementSwitch.thumbTintColor = R.color.primaryPurple()
        agreementSwitch.tintColor = R.color.fourthBackground()
        agreementSwitch.onTintColor = R.color.fourthBackground()
        agreementSwitch.isOn = true
        agreementSwitch.addTarget(self, action: #selector(changedAgreementSwitch), for: .valueChanged)
        agreementView.addSubview(agreementSwitch)
        agreementSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(51)
        }

        agreementTextView.font = UIFont.appFont(size: 16.0, weight: .regular)
        agreementTextView.backgroundColor = .clear
        agreementTextView.textColor = R.color.primaryTitle()
        agreementTextView.textAlignment = .left
        agreementTextView.isEditable = false
        agreementTextView.isSelectable = true
        agreementTextView.dataDetectorTypes = .link
        agreementTextView.text = R.string.localizable.profileEditAgreementTextViewText()
        agreementTextView.minimumZoomScale = 1.0
        agreementTextView.delegate = self
        agreementTextView.isScrollEnabled = false
        agreementView.addSubview(agreementTextView)
        agreementTextView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.trailing.equalTo(agreementSwitch.snp.leading).inset(12)
        }

        stackView.addArrangedSubview(agreementView)
    }
    private func setupButton() {
        button.action = { [weak self] in
            guard let self else { return }
            self.presenter.pressedButton(ProfileEditEntity.EnterData(
                firstName: self.firstNameFieldView.text ?? "",
                lastName: self.lastNameFieldView.text ?? "",
                username: self.usernameTextFieldView.text ?? "",
                email: self.emailTextFieldView.text ?? ""
            ))
        }
        stackView.addArrangedSubview(button)
        stackView.setCustomSpacing(36, after: agreementView)
    }

    // MARK: - Private methods
    private func textFieldDidEndEditingAction(_ textField: TextFieldWithLeftLabel, isRequired: Bool = true) {
        setOffset(offsetStackView)
        if textField.text?.isEmpty ?? true && isRequired {
            textField.setError(message: R.string.localizable.registrationTextFieldEmptyErrorMessage())
        }
    }

    // MARK: - Selectors
    @objc private func changedAgreementSwitch() {
        button.isEnabled = agreementSwitch.isOn
    }
}

// MARK: - ViewInputProtocol implementation
extension ProfileEditViewController: ProfileEditViewInputProtocol {
    func setupView(_ data: ProfileEditEntity.EnterData, title: String, buttonTitle: String, isRegistration: Bool) {
        titleLabel.text = title
        button.setTitle(buttonTitle, for: .normal)
        firstNameFieldView.text = data.firstName
        lastNameFieldView.text = data.lastName
        usernameTextFieldView.text = data.username
        emailTextFieldView.text = data.email

        if isRegistration {
            closeButton.removeFromSuperview()
            closeView.snp.makeConstraints { make in
                make.height.equalTo(50)
            }
            usernameTextFieldView.removeFromSuperview()
            emailTextFieldView.removeFromSuperview()
        }
    }

    func setupDateOfBirth(_ date: String) {
        dateOfBirthFieldView.text = date
    }

    func setupGender(_ gender: String) {
        sexFieldView.text = gender
    }

    func showFieldError(_ message: String, field: ProfileEditInputFields) {
        switch field {
        case .firstName:
            firstNameFieldView.setError(message: message)
        case .username:
            usernameTextFieldView.setError(message: message)
        case .email:
            emailTextFieldView.setError(message: message)
        }
    }
}

extension ProfileEditViewController: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange) -> Bool {
        // TODO: open webview with agreement
        return false
    }
}

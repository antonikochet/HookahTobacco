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

protocol ProfileEditViewInputProtocol: ViewProtocol {
    func setupView(_ data: ProfileEditEntity.EnterData, title: String, buttonTitle: String)
    func setupDateOfBirth(_ date: String)
    func setupGender(_ gender: String)
    func setupCloseButton(isShow: Bool)
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
    var sizes: [SheetSize] = [.fullscreen]

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
    private let dateOfBirthFieldView = TextFieldWithLeftLabel(rounding: .up, type: .text)
    private let sexFieldView = TextFieldWithLeftLabel(rounding: .down, type: .text)
    private let agreementStackView = UIStackView()
    private let agreementTextView = UITextView()
    private let agreementSwitch = UISwitch()
    private let button = ApplyButton(style: .primary)

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
            make.leading.equalToSuperview().offset(-16.0)
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
        firstNameFieldView.setupView(title: R.string.localizable.profileEditFirstNameTitle())
        stackView.addArrangedSubview(firstNameFieldView)
        stackView.setCustomSpacing(36, after: titleLabel)
    }
    private func setupLastNameFieldView() {
        lastNameFieldView.setupView(title: R.string.localizable.profileEditLastNameTitle())
        stackView.addArrangedSubview(lastNameFieldView)
    }
    private func setupDateOfBirthFieldView() {
        dateOfBirthFieldView.setupView(title: R.string.localizable.profileEditDateOfBirthTitle())
        dateOfBirthFieldView.didBeginEditing = { [weak self] in
            self?.view.endEditing(true)
            self?.presenter.pressedDateOfBirthTextField()
        }
        stackView.addArrangedSubview(dateOfBirthFieldView)
        stackView.setCustomSpacing(24, after: lastNameFieldView)
    }
    private func setupSexFieldView() {
        sexFieldView.setupView(title: R.string.localizable.profileEditSexTitle())
        sexFieldView.didBeginEditing = { [weak self] in
                self?.view.endEditing(true)
            self?.presenter.pressedSexTextField()
            }
        stackView.addArrangedSubview(sexFieldView)
    }
    private func setupAgreementSwitchView() {
        agreementTextView.font = UIFont.appFont(size: 16.0, weight: .regular)
        agreementTextView.textColor = R.color.primaryTitle()
        agreementTextView.textAlignment = .left
        agreementTextView.isEditable = false
        agreementTextView.isSelectable = true
        agreementTextView.dataDetectorTypes = .link
        agreementTextView.text = R.string.localizable.profileEditAgreementTextViewText()
        agreementTextView.minimumZoomScale = 1.0
        agreementTextView.delegate = self
        agreementTextView.isScrollEnabled = false
        agreementStackView.addArrangedSubview(agreementTextView)

        agreementSwitch.thumbTintColor = R.color.primaryPurple()
        agreementSwitch.tintColor = R.color.fourthBackground()
        agreementSwitch.onTintColor = R.color.fourthBackground()
        agreementSwitch.isOn = true
        agreementSwitch.addTarget(self, action: #selector(changedAgreementSwitch), for: .valueChanged)
        agreementStackView.addArrangedSubview(agreementSwitch)

        agreementStackView.axis = .horizontal
        agreementStackView.spacing = 12
        agreementStackView.alignment = .center
        stackView.addArrangedSubview(agreementStackView)
    }
    private func setupButton() {
        button.action = { [weak self] in
            guard let self else { return }
            self.presenter.pressedButton(ProfileEditEntity.EnterData(
                firstName: self.firstNameFieldView.text ?? "",
                lastName: self.lastNameFieldView.text ?? ""
            ))
        }
        stackView.addArrangedSubview(button)
        stackView.setCustomSpacing(36, after: agreementStackView)
    }
    // MARK: - Private methods

    // MARK: - Selectors
    @objc private func changedAgreementSwitch() {
        button.isEnabled = agreementSwitch.isOn
    }
}

// MARK: - ViewInputProtocol implementation
extension ProfileEditViewController: ProfileEditViewInputProtocol {
    func setupView(_ data: ProfileEditEntity.EnterData, title: String, buttonTitle: String) {
        titleLabel.text = title
        button.setTitle(buttonTitle, for: .normal)
        firstNameFieldView.text = data.firstName
        lastNameFieldView.text = data.lastName
    }

    func setupDateOfBirth(_ date: String) {
        dateOfBirthFieldView.text = date
    }

    func setupGender(_ gender: String) {
        sexFieldView.text = gender
    }

    func setupCloseButton(isShow: Bool) {
        if !isShow {
            closeButton.removeFromSuperview()
            closeView.snp.makeConstraints { make in
                make.size.equalTo(50)
            }
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

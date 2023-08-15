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
    func setupView(_ data: ProfileEditEntity.EnterData)
    func setupDateOfBirth(_ date: String)
}

protocol ProfileEditViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func pressedButton(_ entity: ProfileEditEntity.EnterData)
    func pressedDateOfBirthTextField()
}

class ProfileEditViewController: HTScrollContentViewController, BottomSheetPresenter {
    // MARK: - BottomSheetPresenter
    var sizes: [SheetSize] = [.fullscreen]

    // MARK: - Public properties
    var presenter: ProfileEditViewOutputProtocol!

    // MARK: - UI properties
    // TODO: добавить email, username, кнопку закрытия при режиме редактирования
    // TODO: добавить добавление фотки когда добавлю на back
    private let firstNameFieldView = AddTextFieldView()
    private let lastNameFieldView = AddTextFieldView()
    private let dateOfBirthFieldView = AddTextFieldView()
    // TODO: добавить поле о согласии обработки персональных данных после добавления на back
    private let button = ApplyButton()

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter.viewDidLoad()
    }

    // MARK: - Setups
    private func setupUI() {
        setupView()
        setupSubviews()
        setupFirstNameFieldView()
        setupLastNameFieldView()
        setupDateOfBirthFieldView()
        setupButton()
        setupConstrainsScrollView()
    }
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    private func setupFirstNameFieldView() {
        contentScrollView.addSubview(firstNameFieldView)
        firstNameFieldView.setupView(textLabel: "Имя",
                                     placeholder: "Введите имя",
                                     delegate: self)
        firstNameFieldView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }
    }
    private func setupLastNameFieldView() {
        contentScrollView.addSubview(lastNameFieldView)
        lastNameFieldView.setupView(textLabel: "Фамилия",
                                     placeholder: "Введите фамилию",
                                     delegate: self)
        lastNameFieldView.snp.makeConstraints { make in
            make.top.equalTo(firstNameFieldView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }
    }
    private func setupDateOfBirthFieldView() {
        contentScrollView.addSubview(dateOfBirthFieldView)
        dateOfBirthFieldView.setupView(textLabel: "Дата рождения",
                                       placeholder: "Выберете дату рождения",
                                       delegate: self)
        dateOfBirthFieldView.snp.makeConstraints { make in
            make.top.equalTo(lastNameFieldView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }
    }
    private func setupButton() {
        contentScrollView.addSubview(button)
        button.setTitle("Регистрация", for: .normal)
        button.action = { [weak self] in
            guard let self else { return }
            self.presenter.pressedButton(ProfileEditEntity.EnterData(
                firstName: self.firstNameFieldView.text ?? "",
                lastName: self.lastNameFieldView.text ?? ""
            ))
        }
        button.snp.makeConstraints { make in
            make.top.equalTo(dateOfBirthFieldView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
            make.bottom.equalToSuperview().inset(spacingBetweenViews)
        }
    }
    // MARK: - Private methods

    // MARK: - Selectors

}

// MARK: - ViewInputProtocol implementation
extension ProfileEditViewController: ProfileEditViewInputProtocol {
    func setupView(_ data: ProfileEditEntity.EnterData) {
        firstNameFieldView.text = data.firstName
        lastNameFieldView.text = data.lastName
    }

    func setupDateOfBirth(_ date: String) {
        dateOfBirthFieldView.text = date
    }
}

// MARK: - UITextFieldDelegate implementation
extension ProfileEditViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if dateOfBirthFieldView.isMyTextField(textField) {
            view.endEditing(true)
            presenter.pressedDateOfBirthTextField()
        }
    }
}

//
//
//  AddTasteViewController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 15.11.2022.
//
//

import UIKit
import SnapKit

protocol AddTasteViewInputProtocol: AnyObject {
    func setupContent(id: String?, taste: String?, type: String?)
    func showSuccess()
    func showError(with message: String)
}

protocol AddTasteViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func didTouchAdded(taste: String?, type: String?)
}

class AddTasteViewController: UIViewController {
    // MARK: - Public properties
    var presenter: AddTasteViewOutputProtocol!

    // MARK: - UI properties
    private let idTextFieldView = AddTextFieldView()
    private let tasteTextFieldView = AddTextFieldView()
    private let typeTextFieldView = AddTextFieldView()
    private let addButton = UIButton.createAppBigButton("Добавить вкус")

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        presenter.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        addButton.createCornerRadius()
    }

    // MARK: - Setups
    private func setupSubviews() {
        view.backgroundColor = .systemBackground

        view.addSubview(idTextFieldView)
        idTextFieldView.isUserInteractionEnabled = false
        idTextFieldView.setupView(textLabel: "Id вкуса",
                                  placeholder: "",
                                  delegate: self)
        idTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(topSpacingFromSuperview)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }

        view.addSubview(tasteTextFieldView)
        tasteTextFieldView.setupView(textLabel: "Вкус",
                                     placeholder: "Введите вкус",
                                     delegate: self)
        tasteTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(idTextFieldView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }

        view.addSubview(typeTextFieldView)
        typeTextFieldView.setupView(textLabel: "Тип вкуса",
                                    placeholder: "Введите тип вкуса",
                                    delegate: self)
        typeTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(tasteTextFieldView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }

        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.top.equalTo(typeTextFieldView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }
        addButton.addTarget(self, action: #selector(didTouchAddButton), for: .touchUpInside)
    }
    // MARK: - Private methods

    // MARK: - Selectors
    @objc private func didTouchAddButton() {
        presenter.didTouchAdded(taste: tasteTextFieldView.text,
                                type: typeTextFieldView.text)
    }
}

// MARK: - ViewInputProtocol implementation
extension AddTasteViewController: AddTasteViewInputProtocol {
    func setupContent(id: String?, taste: String?, type: String?) {
        idTextFieldView.text = id
        tasteTextFieldView.text = taste
        typeTextFieldView.text = type
    }

    func showSuccess() {
        showSuccessView(duration: 0.3, delay: 2)
    }

    func showError(with message: String) {
        showAlertError(title: "Ошибка", message: message)
    }
}

// MARK: - UITextFieldDelegate implementation
extension AddTasteViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if idTextFieldView.isMyTextField(textField) {
            view.endEditing(true)
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if tasteTextFieldView.isMyTextField(textField) {
            return typeTextFieldView.becomeFirstResponderTextField()
        } else if typeTextFieldView.isMyTextField(textField) {
            return view.endEditing(true)
        }
        return false
    }
}

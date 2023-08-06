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
    func setupContent(taste: String?, addButtonText: String)
    func getTableView() -> UITableView
    func updateHeightTableView(_ newHeight: CGFloat)
    func hideAddType()
    func showProgressView()
    func hideProgressView()
}

protocol AddTasteViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func didTouchAdded(taste: String)
    func didAddNewType(_ newType: String)
}

class AddTasteViewController: UIViewController {
    // MARK: - Public properties
    var presenter: AddTasteViewOutputProtocol!

    // MARK: - UI properties
    private let tasteTextFieldView = AddTextFieldView()
    private let typeSelectLabel = UILabel()
    private let typeSelectTableView = UITableView(frame: .zero, style: .grouped)
    private let openAddTypeButton = UIButton.createAppBigButton("Добавить тип вкуса", fontSise: 16)
    private let addTypeView = UIView()
    private let addTypeTextFieldView = AddTextFieldView()
    private let addTypeButton = UIButton.createAppBigButton("Создать тип")
    private let closeTypeViewButton = IconButton()
    private let addButton = UIButton.createAppBigButton("Добавить вкус")
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)

    private var addButtonTopToAddTypeButtonConstraint: Constraint?
    private var addButtonTopToAddTypeViewConstraint: Constraint?

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        addButton.createCornerRadius()
        openAddTypeButton.createCornerRadius()
        addTypeButton.createCornerRadius()
    }

    // MARK: - Setups
    private func setupUI() {
        setupView()
        setupTasteTextFieldView()
        setupTypeSelectLabel()
        setupTypeSelectTableView()
        setupOpenAddTypeButton()
        setupAddTypeView()
        setupAddTypeTextFieldView()
        setupAddTypeButton()
        setupCloseAddTypeViewButton()
        setupAddButton()
        setupActivityIndicator()
    }
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    private func setupTasteTextFieldView() {
        view.addSubview(tasteTextFieldView)
        tasteTextFieldView.setupView(textLabel: "Вкус",
                                     placeholder: "Введите вкус",
                                     delegate: self)
        tasteTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }
    }
    private func setupTypeSelectLabel() {
        view.addSubview(typeSelectLabel)
        typeSelectLabel.text = "Выбрать тип вкуса табака"
        typeSelectLabel.snp.makeConstraints { make in
            make.top.equalTo(tasteTextFieldView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }
    }
    private func setupTypeSelectTableView() {
        view.addSubview(typeSelectTableView)
        typeSelectTableView.layer.cornerRadius = 6
        typeSelectTableView.layer.borderColor = UIColor.systemGray4.cgColor
        typeSelectTableView.layer.borderWidth = 1
        typeSelectTableView.snp.makeConstraints { make in
            make.top.equalTo(typeSelectLabel.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
            make.height.equalTo(0)
        }
    }
    private func setupOpenAddTypeButton() {
        view.addSubview(openAddTypeButton)
        openAddTypeButton.snp.makeConstraints { make in
            make.top.equalTo(typeSelectTableView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
            make.height.equalTo(40)
        }
        openAddTypeButton.addTarget(self, action: #selector(didTouchOpenAddTypeButton), for: .touchUpInside)
    }
    private func setupAddTypeView() {
        view.addSubview(addTypeView)
        addTypeView.layer.cornerRadius = 12
        addTypeView.layer.borderColor = UIColor.black.cgColor
        addTypeView.layer.borderWidth = 1.0
        addTypeView.clipsToBounds = true
        addTypeView.backgroundColor = .systemGray6
        addTypeView.isHidden = true
        addTypeView.snp.makeConstraints { make in
            make.top.equalTo(openAddTypeButton.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }
    }
    private func setupAddTypeTextFieldView() {
        addTypeView.addSubview(addTypeTextFieldView)
        addTypeTextFieldView.setupView(textLabel: "Название типа вкуса",
                                       placeholder: "Введите название")
        addTypeTextFieldView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(spacingBetweenViews)
            make.height.equalTo(addTypeTextFieldView.heightView)
            make.leading.trailing.equalToSuperview().inset(spacingBetweenViews)
        }
    }
    private func setupAddTypeButton() {
        addTypeView.addSubview(addTypeButton)
        addTypeButton.snp.makeConstraints { make in
            make.top.equalTo(addTypeTextFieldView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(spacingBetweenViews)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().inset(spacingBetweenViews)
        }
        addTypeButton.addTarget(self, action: #selector(didTouchAddTypeButton), for: .touchUpInside)
    }
    private func setupCloseAddTypeViewButton() {
        addTypeView.addSubview(closeTypeViewButton)
        closeTypeViewButton.action = { [weak self] in
            guard let self else { return }
            self.addTypeView.isHidden = true
            self.addTypeTextFieldView.isHidden = true
            self.addTypeButton.isHidden = true
            self.addButtonTopToAddTypeViewConstraint?.isActive = false
            self.addButtonTopToAddTypeButtonConstraint?.isActive = true
        }
        closeTypeViewButton.imageSize = 20.0
        closeTypeViewButton.image = UIImage(systemName: "multiply")
        closeTypeViewButton.backgroundColor = .systemGray2
        closeTypeViewButton.imageColor = .white
        closeTypeViewButton.createCornerRadius()
        closeTypeViewButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(10)
        }
    }
    private func setupAddButton() {
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            addButtonTopToAddTypeViewConstraint = make.top.equalTo(addTypeView.snp.bottom)
                                                          .offset(spacingBetweenViews).constraint
            addButtonTopToAddTypeButtonConstraint = make.top.equalTo(openAddTypeButton.snp.bottom)
                                                          .offset(spacingBetweenViews).constraint
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
            make.height.equalTo(45)
        }
        addButtonTopToAddTypeViewConstraint?.isActive = false
        addButton.addTarget(self, action: #selector(didTouchAddButton), for: .touchUpInside)
    }
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        activityIndicator.hidesWhenStopped = true
    }
    // MARK: - Private methods

    // MARK: - Selectors
    @objc private func didTouchAddButton() {
        presenter.didTouchAdded(taste: tasteTextFieldView.text ?? "")
    }

    @objc private func didTouchOpenAddTypeButton() {
        addTypeView.isHidden = false
        addTypeTextFieldView.isHidden = false
        addTypeButton.isHidden = false
        addButtonTopToAddTypeViewConstraint?.isActive = true
        addButtonTopToAddTypeButtonConstraint?.isActive = false
    }

    @objc private func didTouchAddTypeButton() {
        view.endEditing(true)
        presenter.didAddNewType(addTypeTextFieldView.text ?? "")
    }
}

// MARK: - ViewInputProtocol implementation
extension AddTasteViewController: AddTasteViewInputProtocol {
    func setupContent(taste: String?, addButtonText: String) {
        tasteTextFieldView.text = taste
        addButton.setTitle(addButtonText, for: .normal)
    }

    func getTableView() -> UITableView {
        typeSelectTableView
    }

    func updateHeightTableView(_ newHeight: CGFloat) {
        typeSelectTableView.snp.updateConstraints { make in
            make.height.equalTo(newHeight)
        }
    }

    func hideAddType() {
        addTypeTextFieldView.text = ""
        addTypeView.isHidden = true
        addButtonTopToAddTypeViewConstraint?.isActive = false
        addButtonTopToAddTypeButtonConstraint?.isActive = true
    }

    func showProgressView() {
        activityIndicator.startAnimating()
    }

    func hideProgressView() {
        activityIndicator.stopAnimating()
    }
}

// MARK: - UITextFieldDelegate implementation
extension AddTasteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

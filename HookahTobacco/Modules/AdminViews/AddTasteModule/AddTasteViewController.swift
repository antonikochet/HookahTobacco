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
    func showProgressView()
    func hideProgressView()
}

protocol AddTasteViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func didTouchAdded(taste: String)
}

class AddTasteViewController: UIViewController {
    // MARK: - Public properties
    var presenter: AddTasteViewOutputProtocol!

    // MARK: - UI properties
    private let tasteTextFieldView = AddTextFieldView()
    private let typeSelectLabel = UILabel()
    private let typeSelectTableView = UITableView(frame: .zero, style: .grouped)
    private let addButton = UIButton.createAppBigButton("Добавить вкус")
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        addButton.createCornerRadius()
    }

    // MARK: - Setups
    private func setupUI() {
        setupView()
        setupTasteTextFieldView()
        setupTypeSelectLabel()
        setupTypeSelectTableView()
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
    private func setupAddButton() {
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.top.equalTo(typeSelectTableView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }
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

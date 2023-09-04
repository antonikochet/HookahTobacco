//
//
//  AddCountryViewController.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 06.08.2023.
//
//

import UIKit
import SnapKit

protocol AddCountryViewInputProtocol: ViewProtocol {
    func getTableView() -> UITableView
    func showAddView(text: String, titleButton: String)
    func hideAddView()
}

protocol AddCountryViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func viewWillDisappear()
    func pressedAddButton()
    func pressedAddNewButton(_ name: String)
    func pressedCloseAddView()
}

class AddCountryViewController: BaseViewController {
    // MARK: - Public properties
    var presenter: AddCountryViewOutputProtocol!

    // MARK: - UI properties
    private let addButton = ApplyButton(style: .primary)
    private let addView = UIView()
    private let addTextFieldView = AddTextFieldView()
    private let addNewButton = ApplyButton(style: .primary)
    private let closeAddViewButton = IconButton()
    private let tableView = UITableView(frame: .zero, style: .grouped)

    private var tableViewTopToAddButtonConstraint: Constraint?
    private var tableViewTopToAddViewConstraint: Constraint?

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear()
    }

    // MARK: - Setups
    private func setupUI() {
        setupView()
        setupAddCountryButton()
        setupAddView()
        setupAddTextFieldView()
        setupAddNewCountryButton()
        setupCloseAddViewButton()
        setupTableView()
    }
    private func setupView() {
        title = "Добавление стран"
        view.backgroundColor = .systemBackground
    }
    private func setupAddCountryButton() {
        addButton.setTitle("Добавить новую страну", for: .normal)
        addButton.action = { [weak self] in
            self?.presenter.pressedAddButton()
        }
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }
    }
    private func setupAddView() {
        view.addSubview(addView)
        addView.layer.cornerRadius = 12
        addView.layer.borderColor = UIColor.black.cgColor
        addView.layer.borderWidth = 1.0
        addView.clipsToBounds = true
        addView.backgroundColor = .systemGray6
        addView.isHidden = true
        addView.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }
    }
    private func setupAddTextFieldView() {
        addView.addSubview(addTextFieldView)
        addTextFieldView.setupView(textLabel: "Название страны",
                                   placeholder: "Введите название")
        addTextFieldView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(spacingBetweenViews)
        }
    }
    private func setupAddNewCountryButton() {
        addNewButton.setTitle("Добавить страну", for: .normal)
        addNewButton.action = { [weak self] in
            guard let self else { return }
            self.presenter.pressedAddNewButton(self.addTextFieldView.text ?? "")
        }
        addView.addSubview(addNewButton)
        addNewButton.snp.makeConstraints { make in
            make.top.equalTo(addTextFieldView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(spacingBetweenViews)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().inset(spacingBetweenViews)
        }
    }
    private func setupCloseAddViewButton() {
        addView.addSubview(closeAddViewButton)
        closeAddViewButton.action = { [weak self] in
            guard let self else { return }
            self.presenter.pressedCloseAddView()
        }
        closeAddViewButton.imageSize = 20.0
        closeAddViewButton.image = UIImage(systemName: "multiply")
        closeAddViewButton.backgroundColor = .systemGray2
        closeAddViewButton.imageColor = .white
        closeAddViewButton.createCornerRadius()
        closeAddViewButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(10)
        }
    }
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            tableViewTopToAddViewConstraint = make.top.equalTo(addView.snp.bottom)
                                                    .offset(spacingBetweenViews).constraint
            tableViewTopToAddButtonConstraint = make.top.equalTo(addButton.snp.bottom)
                                                    .offset(spacingBetweenViews).constraint
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        tableViewTopToAddViewConstraint?.isActive = false
    }

    // MARK: - Private methods

    // MARK: - Selectors

}

// MARK: - ViewInputProtocol implementation
extension AddCountryViewController: AddCountryViewInputProtocol {
    func getTableView() -> UITableView {
        tableView
    }

    func showAddView(text: String, titleButton: String) {
        addTextFieldView.text = text
        addNewButton.setTitle(titleButton, for: .normal)
        addView.isHidden = false
        addTextFieldView.isHidden = false
        addNewButton.isHidden = false
        tableViewTopToAddViewConstraint?.isActive = true
        tableViewTopToAddButtonConstraint?.isActive = false
    }

    func hideAddView() {
        addTextFieldView.text = ""
        addView.isHidden = true
        addTextFieldView.isHidden = true
        addNewButton.isHidden = true
        tableViewTopToAddViewConstraint?.isActive = false
        tableViewTopToAddButtonConstraint?.isActive = true
    }
}

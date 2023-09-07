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
    private let tableView = UITableView()

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
        title = R.string.localizable.addCountryTitle()
        view.backgroundColor = R.color.primaryBackground()
    }
    private func setupAddCountryButton() {
        addButton.setTitle(R.string.localizable.addCountryAddNewCountryButtonTitle(), for: .normal)
        addButton.action = { [weak self] in
            self?.presenter.pressedAddButton()
        }
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16.0)
            make.leading.trailing.equalToSuperview().inset(32.0)
        }
    }
    private func setupAddView() {
        view.addSubview(addView)
        addView.layer.cornerRadius = 12
        addView.layer.borderColor = R.color.primaryBlack()?.cgColor
        addView.layer.borderWidth = 1.0
        addView.clipsToBounds = true
        addView.backgroundColor = R.color.secondaryBackground()
        addView.isHidden = true
        addView.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(16.0)
            make.leading.trailing.equalToSuperview().inset(32.0)
        }
    }
    private func setupAddTextFieldView() {
        addView.addSubview(addTextFieldView)
        addTextFieldView.setupView(textLabel: R.string.localizable.addCountryCountryTextFieldText(),
                                   placeholder: R.string.localizable.addCountryCountryTextFieldPlaceholder())
        addTextFieldView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.leading.trailing.equalToSuperview().inset(32.0)
        }
    }
    private func setupAddNewCountryButton() {
        addNewButton.setTitle(R.string.localizable.addCountryAddButtonAddTitle(), for: .normal)
        addNewButton.action = { [weak self] in
            guard let self else { return }
            self.presenter.pressedAddNewButton(self.addTextFieldView.text ?? "")
        }
        addView.addSubview(addNewButton)
        addNewButton.snp.makeConstraints { make in
            make.top.equalTo(addTextFieldView.snp.bottom).offset(16.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.bottom.equalToSuperview().inset(16.0)
        }
    }
    private func setupCloseAddViewButton() {
        addView.addSubview(closeAddViewButton)
        closeAddViewButton.action = { [weak self] in
            guard let self else { return }
            self.presenter.pressedCloseAddView()
        }
        closeAddViewButton.image = R.image.close()
        closeAddViewButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(10)
        }
    }
    private func setupTableView() {
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
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

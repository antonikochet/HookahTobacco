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

protocol AddTasteViewInputProtocol: ViewProtocol {
    func setupContent(taste: String?, addButtonText: String)
    func getTableView() -> UITableView
    func updateHeightTableView(_ newHeight: CGFloat)
    func hideAddType()
}

protocol AddTasteViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func didTouchAdded(taste: String)
    func didAddNewType(_ newType: String)
}

class AddTasteViewController: BaseViewController, BottomSheetPresenter {
    // MARK: - BottomSheetPresenter
    var isShowGrip: Bool = false
    var dismissOnPull: Bool = false

    // MARK: - Public properties
    var presenter: AddTasteViewOutputProtocol!

    // MARK: - UI properties
    private let tasteTextFieldView = AddTextFieldView()
    private let typeSelectLabel = UILabel()
    private let typeSelectTableView = UITableView()
    private let openAddTypeButton = ApplyButton(style: .secondary)
    private let addTypeView = UIView()
    private let addTypeTextFieldView = AddTextFieldView()
    private let addTypeButton = ApplyButton(style: .secondary)
    private let closeTypeViewButton = IconButton()
    private let addButton = ApplyButton(style: .primary)

    private var addButtonTopToAddTypeButtonConstraint: Constraint?

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
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
    }
    private func setupView() {
        view.backgroundColor = R.color.primaryBackground()
    }
    private func setupTasteTextFieldView() {
        view.addSubview(tasteTextFieldView)
        tasteTextFieldView.setupView(textLabel: R.string.localizable.addTasteTasteTextFieldText(),
                                     placeholder: R.string.localizable.addTasteTasteTextFieldPlaceholder(),
                                     delegate: self)
        tasteTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(16.0)
            make.leading.trailing.equalToSuperview().inset(32.0)
        }
    }
    private func setupTypeSelectLabel() {
        view.addSubview(typeSelectLabel)
        typeSelectLabel.setForTitleName()
        typeSelectLabel.text = R.string.localizable.addTasteTypeLabelText()
        typeSelectLabel.snp.makeConstraints { make in
            make.top.equalTo(tasteTextFieldView.snp.bottom).offset(16.0)
            make.leading.trailing.equalToSuperview().inset(32.0)
        }
    }
    private func setupTypeSelectTableView() {
        view.addSubview(typeSelectTableView)
        if #available(iOS 15.0, *) {
            typeSelectTableView.sectionHeaderTopPadding = 0.0
        }
        typeSelectTableView.backgroundColor = R.color.secondaryBackground()
        typeSelectTableView.layer.cornerRadius = 6
        typeSelectTableView.layer.borderColor = R.color.primarySubtitle()?.cgColor
        typeSelectTableView.layer.borderWidth = 1
        typeSelectTableView.snp.makeConstraints { make in
            make.top.equalTo(typeSelectLabel.snp.bottom).offset(8.0)
            make.leading.trailing.equalToSuperview().inset(32.0)
            make.height.equalTo(0).priority(999)
        }
    }
    private func setupOpenAddTypeButton() {
        openAddTypeButton.setTitle(R.string.localizable.addTasteAddTypeButtonTitle(), for: .normal)
        openAddTypeButton.action = { [weak self] in
            guard let self else { return }
            self.addTypeView.isHidden = false
            self.addTypeTextFieldView.isHidden = false
            self.addTypeButton.isHidden = false
            self.addButtonTopToAddTypeButtonConstraint?.isActive = false
            self.sheetViewController?.updateIntrinsicHeight()
        }
        view.addSubview(openAddTypeButton)
        openAddTypeButton.snp.makeConstraints { make in
            make.top.equalTo(typeSelectTableView.snp.bottom).offset(16.0)
            make.leading.trailing.equalToSuperview().inset(32.0)
        }
    }
    private func setupAddTypeView() {
        view.addSubview(addTypeView)
        addTypeView.layer.cornerRadius = 12
        addTypeView.layer.borderColor = R.color.primaryTitle()?.cgColor
        addTypeView.layer.borderWidth = 1.0
        addTypeView.clipsToBounds = true
        addTypeView.backgroundColor = R.color.secondaryBackground()
        addTypeView.isHidden = true
        addTypeView.snp.makeConstraints { make in
            make.top.equalTo(openAddTypeButton.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }
    }
    private func setupAddTypeTextFieldView() {
        addTypeView.addSubview(addTypeTextFieldView)
        addTypeTextFieldView.setupView(textLabel: R.string.localizable.addTasteTypeTextFieldText(),
                                       placeholder: R.string.localizable.addTasteTypeTextFieldPlaceholder())
        addTypeTextFieldView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(spacingBetweenViews)
        }
    }
    private func setupAddTypeButton() {
        addTypeButton.setTitle(R.string.localizable.addTasteTypeAddButtonTitle(), for: .normal)
        addTypeButton.action = { [weak self] in
            guard let self else { return }
            view.endEditing(true)
            self.presenter.didAddNewType(self.addTypeTextFieldView.text ?? "")
        }
        addTypeView.addSubview(addTypeButton)
        addTypeButton.snp.makeConstraints { make in
            make.top.equalTo(addTypeTextFieldView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(spacingBetweenViews)
            make.bottom.equalToSuperview().inset(spacingBetweenViews)
        }
    }
    private func setupCloseAddTypeViewButton() {
        addTypeView.addSubview(closeTypeViewButton)
        closeTypeViewButton.action = { [weak self] in
            guard let self else { return }
            self.addTypeView.isHidden = true
            self.addTypeTextFieldView.isHidden = true
            self.addTypeButton.isHidden = true
            self.addButtonTopToAddTypeButtonConstraint?.isActive = true
            self.sheetViewController?.updateIntrinsicHeight()
        }
        closeTypeViewButton.image = R.image.close()
        closeTypeViewButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(10)
        }
    }
    private func setupAddButton() {
        addButton.setTitle(R.string.localizable.addTasteAddButtonAdd(), for: .normal)
        addButton.action = { [weak self] in
            self?.presenter.didTouchAdded(taste: self?.tasteTextFieldView.text ?? "")
        }
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.top.equalTo(addTypeView.snp.bottom).offset(spacingBetweenViews).priority(.medium)
            addButtonTopToAddTypeButtonConstraint = make.top.equalTo(openAddTypeButton.snp.bottom)
                                                          .offset(spacingBetweenViews).constraint
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(spacingBetweenViews)
        }
    }

    // MARK: - Private methods

    // MARK: - Selectors

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
            make.height.equalTo(newHeight).priority(999)
        }
        sheetViewController?.updateIntrinsicHeight()
    }

    func hideAddType() {
        addTypeTextFieldView.text = ""
        addTypeView.isHidden = true
        addButtonTopToAddTypeButtonConstraint?.isActive = true
        sheetViewController?.updateIntrinsicHeight()
    }
}

// MARK: - UITextFieldDelegate implementation
extension AddTasteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

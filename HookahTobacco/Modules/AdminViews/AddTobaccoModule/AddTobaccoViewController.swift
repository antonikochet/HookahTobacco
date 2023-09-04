//
//
//  AddTobaccoViewController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import UIKit
import SnapKit

protocol AddTobaccoViewInputProtocol: ViewProtocol {
    func getTasteCollectionView() -> CustomCollectionView
    func clearView()
    func setupContent(_ viewModel: AddTobaccoEntity.ViewModel)
    func setupSelectedManufacturer(_ index: Int)
    func setupSelectedTobaccoLine(_ index: Int)
    func setupMainImage(_ image: Data?, textButton: String)
    func updateTasteButton(isShow: Bool)
}

enum AddPicketType {
    case manufacturer
    case tobaccoLine
}

protocol AddTobaccoViewOutputProtocol: AnyObject {
    func pressedButtonAdded(with data: AddTobaccoEntity.EnteredData)
    func didSelected(by index: Int, type: AddPicketType)
    func didSelectMainImage(with imageURL: URL)
    func numbreOfRows(type: AddPicketType) -> Int
    func receiveRow(by index: Int, type: AddPicketType) -> String
    func receiveIndexRow(for title: String, type: AddPicketType) -> Int
    func viewDidLoad()
    func didTouchSelectedTastes()
}

final class AddTobaccoViewController: HTScrollContentViewController {
    // MARK: - Public properties
    var presenter: AddTobaccoViewOutputProtocol!

    // MARK: - UI properties
    private let nameView = AddTextFieldView()
    private let manufacturerPickerView = AddPickerView()
    private let tasteCollectionView = CustomCollectionView()
    private let tasteButton = ApplyButton(style: .primary)
    private let descriptionView = AddTextView()
    private let tobaccoLinePickerView = AddPickerView()
    private let imagePickerView = ImageButtonPickerView()
    private let addedButton = ApplyButton(style: .primary)

    private var descriptionViewTopToTasteButtonConstraint: Constraint?

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        overrideUserInterfaceStyle = .light

        setupSubviews()
        presenter.viewDidLoad()
    }

    override func hideViewTapped() {
        super.hideViewTapped()
        manufacturerPickerView.hideView()
        tobaccoLinePickerView.hideView()
    }

    // MARK: - Setups
    override func setupSubviews() {
        super.setupSubviews()
        setupNameView()
        setupManufacturerPickerView()
        setupTasteCollectionView()
        setupTasteButton()
        setupDescriptionView()
        setupTobaccoLinePickerView()
        setupAddedButton()
        setupImagePickerView()
        setupConstrainsScrollView(top: view.safeAreaLayoutGuide,
                                  bottom: addedButton.snp.top,
                                  bottomConstant: -spacingBetweenViews)
    }
    private func setupNameView() {
        contentScrollView.addSubview(nameView)
        nameView.setupView(textLabel: "Название",
                           placeholder: "Введите название производителя...",
                           delegate: self)
        nameView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topSpacingFromSuperview)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }
    }
    private func setupManufacturerPickerView() {
        contentScrollView.addSubview(manufacturerPickerView)
        manufacturerPickerView.setupView(text: "Выбрать производителя табака")
        manufacturerPickerView.delegate = self
        manufacturerPickerView.snp.makeConstraints { make in
            make.top.equalTo(nameView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }
    }
    private func setupTasteCollectionView() {
        contentScrollView.addSubview(tasteCollectionView)
        tasteCollectionView.snp.makeConstraints { make in
            make.top.equalTo(manufacturerPickerView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }
        let tapTasteCollection = UITapGestureRecognizer(target: self, action: #selector(touchForSelectTastes))
        tasteCollectionView.addGestureRecognizer(tapTasteCollection)
    }
    private func setupTasteButton() {
        tasteButton.setTitle("Добавить вкусы", for: .normal)
        tasteButton.action = { [weak self] in
            self?.presenter.didTouchSelectedTastes()
        }
        contentScrollView.addSubview(tasteButton)
        tasteButton.snp.makeConstraints { make in
            make.top.equalTo(tasteCollectionView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }
    }
    private func setupDescriptionView() {
        contentScrollView.addSubview(descriptionView)
        descriptionView.setupView(textLabel: "Описание табака (не обязательно)")
        descriptionView.snp.makeConstraints { make in
            descriptionViewTopToTasteButtonConstraint = make.top.equalTo(tasteButton.snp.bottom).offset(spacingBetweenViews).constraint
            make.top.equalTo(tasteCollectionView.snp.bottom).offset(spacingBetweenViews).priority(.medium)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }
    }
    private func setupTobaccoLinePickerView() {
        contentScrollView.addSubview(tobaccoLinePickerView)
        tobaccoLinePickerView.setupView(text: "Выбрать линейку табака")
        tobaccoLinePickerView.delegate = self
        tobaccoLinePickerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }
    }
    private func setupAddedButton() {
        addedButton.action = { [weak self] in
            guard let self else { return }
            let data = AddTobaccoEntity.EnteredData(
                name: self.nameView.text,
                description: self.descriptionView.text)
            self.presenter.pressedButtonAdded(with: data)
        }
        view.addSubview(addedButton)
        addedButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(spacingBetweenViews)
            make.height.equalTo(50)
        }
    }
    private func setupImagePickerView() {
        contentScrollView.addSubview(imagePickerView)
        imagePickerView.snp.makeConstraints { make in
            make.top.equalTo(tobaccoLinePickerView.snp.bottom).inset(-spacingBetweenViews)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(spacingBetweenViews)
            make.width.greaterThanOrEqualToSuperview().dividedBy(3)
            make.width.lessThanOrEqualToSuperview().dividedBy(2)
            make.height.equalTo(imagePickerView.snp.width)
            make.bottom.equalToSuperview().inset(16.0)
        }
        imagePickerView.delegate = self
    }

    // MARK: - Private methods
    private func changeManufacturerPickerView(by row: Int) {
        manufacturerPickerView.text = presenter.receiveRow(by: row, type: .manufacturer)
    }

    private func changeTobaccoLinePickerView(by row: Int) {
        tobaccoLinePickerView.text = presenter.receiveRow(by: row, type: .tobaccoLine)
    }

    // MARK: - Selectors
    @objc
    private func touchForSelectTastes() {
        presenter.didTouchSelectedTastes()
    }
}

// MARK: - ViewInputProtocol implementation
extension AddTobaccoViewController: AddTobaccoViewInputProtocol {
    func getTasteCollectionView() -> CustomCollectionView {
        tasteCollectionView
    }

    func clearView() {
        nameView.text = ""
        descriptionView.text = ""
        changeManufacturerPickerView(by: 0)
        changeTobaccoLinePickerView(by: 0)
        nameView.becomeFirstResponderTextField()
        imagePickerView.image = nil
    }

    func setupContent(_ viewModel: AddTobaccoEntity.ViewModel) {
        nameView.text = viewModel.name
        descriptionView.text = viewModel.description
        addedButton.setTitle(viewModel.textButton, for: .normal)
    }

    func setupSelectedManufacturer(_ index: Int) {
        changeManufacturerPickerView(by: index)
    }

    func setupSelectedTobaccoLine(_ index: Int) {
        changeTobaccoLinePickerView(by: index)
    }

    func setupMainImage(_ image: Data?, textButton: String) {
//        imagePickerView.textButton = textButton
        if let image = image {
            imagePickerView.image = UIImage(data: image)
        }
    }

    func updateTasteButton(isShow: Bool) {
        tasteButton.isHidden = !isShow
        descriptionViewTopToTasteButtonConstraint?.isActive = isShow
    }
}

// MARK: - UITextFieldDelegate implementation
extension AddTobaccoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameView.isMyTextField(textField) {
            return descriptionView.becomeFirstResponder()
        }
        return false
    }
}

// MARK: - ImagePickerViewDelegate implementation
extension AddTobaccoViewController: ImagePickerViewDelegate {
    func present(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }

    func didSelectedImage(by fileURL: URL) {
        presenter.didSelectMainImage(with: fileURL)
    }

    func didCancel() {

    }
}

// MARK: - AddPickerViewDelegate implementation
extension AddTobaccoViewController: AddPickerViewDelegate {
    func receiveNumberOfRows(_ pickerView: AddPickerView) -> Int {
        if pickerView === manufacturerPickerView {
            return presenter.numbreOfRows(type: .manufacturer)
        } else if pickerView === tobaccoLinePickerView {
            return presenter.numbreOfRows(type: .tobaccoLine)
        }
        return 0
    }

    func receiveRow(_ pickerView: AddPickerView, by row: Int) -> String {
        if pickerView === manufacturerPickerView {
            return presenter.receiveRow(by: row, type: .manufacturer)
        } else if pickerView === tobaccoLinePickerView {
            return presenter.receiveRow(by: row, type: .tobaccoLine)
        }
        return ""
    }

    func didSelected(_ pickerView: AddPickerView, by row: Int) {
        if pickerView === manufacturerPickerView {
            presenter.didSelected(by: row, type: .manufacturer)
        } else if pickerView === tobaccoLinePickerView {
            presenter.didSelected(by: row, type: .tobaccoLine)
        }
    }

    func receiveIndex(_ pickerView: AddPickerView, for title: String) -> Int {
        if pickerView === manufacturerPickerView {
            return presenter.receiveIndexRow(for: title, type: .manufacturer)
        } else if pickerView === tobaccoLinePickerView {
            return presenter.receiveIndexRow(for: title, type: .tobaccoLine)
        }
        return -1
    }
}

extension AddTobaccoViewController {
    var imageHeightRelativeToWidth: CGFloat { 0.5 }
}

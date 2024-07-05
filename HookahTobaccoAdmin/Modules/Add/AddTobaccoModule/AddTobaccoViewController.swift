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
    func setupMainImage(_ image: Data?)
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
    private let imageContainerView = UIView()
    private let imagePickerView = ImageButtonPickerView()
    private let addedButton = ApplyButton(style: .primary )

    override var stackViewInset: UIEdgeInsets {
        UIEdgeInsets(horizontal: 16.0, vertical: 16.0)
    }

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.color.primaryBackground()

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
                                  bottomConstant: -16.0)
    }
    private func setupNameView() {
        stackView.addArrangedSubview(nameView)
        nameView.setupView(textLabel: R.string.localizable.addTobaccoNameTextFieldTitle(),
                           placeholder: R.string.localizable.addTobaccoNameTextFieldPlaceholder(),
                           delegate: self)
    }
    private func setupManufacturerPickerView() {
        stackView.addArrangedSubview(manufacturerPickerView)
        manufacturerPickerView.setupView(text: R.string.localizable.addTobaccoManufacturerText())
        manufacturerPickerView.delegate = self
    }
    private func setupTasteCollectionView() {
        stackView.addArrangedSubview(tasteCollectionView)
        let tapTasteCollection = UITapGestureRecognizer(target: self, action: #selector(touchForSelectTastes))
        tasteCollectionView.addGestureRecognizer(tapTasteCollection)
    }
    private func setupTasteButton() {
        tasteButton.setTitle(R.string.localizable.addTobaccoTasteButtonTitle(), for: .normal)
        tasteButton.action = { [weak self] in
            self?.presenter.didTouchSelectedTastes()
        }
        stackView.addArrangedSubview(tasteButton)
    }
    private func setupDescriptionView() {
        stackView.addArrangedSubview(descriptionView)
        descriptionView.setupView(textLabel: R.string.localizable.addTobaccoDescriptionTitle())
    }
    private func setupTobaccoLinePickerView() {
        stackView.addArrangedSubview(tobaccoLinePickerView)
        tobaccoLinePickerView.setupView(text: R.string.localizable.addTobaccoTobaccoLineTitle())
        tobaccoLinePickerView.delegate = self
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
            make.leading.trailing.equalToSuperview().inset(32.0)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16.0)
        }
    }
    private func setupImagePickerView() {
        stackView.addArrangedSubview(imageContainerView)
        imageContainerView.addSubview(imagePickerView)
        imagePickerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(150)
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

    func setupMainImage(_ image: Data?) {
        if let image = image {
            imagePickerView.image = UIImage(data: image)
        }
    }

    func updateTasteButton(isShow: Bool) {
        tasteButton.isHidden = !isShow
        if isShow {
            if let index = stackView.arrangedSubviews.firstIndex(of: tasteCollectionView) {
                stackView.insertArrangedSubview(tasteButton, at: index)
            }
            stackView.removeArrangedSubview(tasteCollectionView)
        } else {
            if let index = stackView.arrangedSubviews.firstIndex(of: tasteButton) {
                stackView.insertArrangedSubview(tasteCollectionView, at: index)
            }
            stackView.removeArrangedSubview(tasteButton)
        }
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

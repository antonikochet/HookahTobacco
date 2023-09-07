//
//
//  AddManufacturerViewController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import UIKit
import SnapKit

protocol AddManufacturerViewInputProtocol: ViewProtocol {
    func getTobaccoLineCollectionView() -> CustomCollectionView
    func clearView()
    func setupContent(_ viewModel: AddManufacturerEntity.ViewModel)
    func setupImageManufacturer(_ image: Data?)
    func setupSelectedCountry(_ index: Int)
    func receivedResultAddTobaccoLine(isResult: Bool)
    func showLoading()
    func hideLoading()
}

protocol AddManufacturerViewOutputProtocol {
    func pressedAddButton(with enteredData: AddManufacturerEntity.EnterData)
    func selectedImage(with urlFile: URL)
    func viewDidLoad()

    func pressedAddTobaccoLine()

    func pressedAddCountry()
    func numberOfRowsCountries() -> Int
    func receiveRowCountry(by index: Int) -> String
    func receiveIndexRowCountry(for title: String) -> Int
    func didSelectedCounty(by index: Int)
}

final class AddManufacturerViewController: HTScrollContentViewController {
    // MARK: - Public properties
    var presenter: AddManufacturerViewOutputProtocol!

    // MARK: - UI properties
    private let nameTextFieldView = AddTextFieldView()
    private let countryPicketView = AddPickerView(isAddButton: true)
    private let descriptionView = AddTextView()
    private let linkTextFieldView = AddTextFieldView()
    private let tobaccoLineCollectionView = CustomCollectionView()
    private let addTobaccoLineButton = ApplyButton(style: .secondary)
    private let imageContainerView = UIView()
    private let imagePickerView = ImageButtonPickerView()
    private let addedButton = ApplyButton(style: .primary)

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
        countryPicketView.hideView()
    }
    // MARK: - Setups
    override func setupSubviews() {
        super.setupSubviews()
        setupNameTextField()
        setupCountryPickerView()
        setupDescriptionView()
        setupLinkTextFieldView()
        setupAddTobaccoLineView()
        setupAddButton()
        setupImagePickerView()
        setupConstrainsScrollView(top: view.safeAreaLayoutGuide,
                                  bottom: addedButton.snp.top, bottomConstant: -spacingBetweenViews)
    }
    private func setupNameTextField() {
        stackView.addArrangedSubview(nameTextFieldView)
        nameTextFieldView.setupView(textLabel: R.string.localizable.addManufacturerNameTextFieldTitle(),
                                    placeholder: R.string.localizable.addManufacturerNameTextFieldPlaceholder(),
                                    delegate: self)
    }
    private func setupCountryPickerView() {
        stackView.addArrangedSubview(countryPicketView)
        countryPicketView.setupView(text: R.string.localizable.addManufacturerCountryText())
        countryPicketView.addButtonAction = { [weak self] in
            self?.presenter.pressedAddCountry()
        }
        countryPicketView.delegate = self
    }
    private func setupDescriptionView() {
        stackView.addArrangedSubview(descriptionView)
        descriptionView.setupView(textLabel: R.string.localizable.addManufacturerDescriptionTitle())
    }
    private func setupLinkTextFieldView() {
        stackView.addArrangedSubview(linkTextFieldView)
        linkTextFieldView.setupView(textLabel: R.string.localizable.addManufacturerLinkTextFieldTitle(),
                                    placeholder: R.string.localizable.addManufacturerLinkTextFieldPlaceholder(),
                                    delegate: self)
    }
    private func setupAddTobaccoLineView() {
        stackView.addArrangedSubview(tobaccoLineCollectionView)

        addTobaccoLineButton.setTitle(R.string.localizable.addManufacturerAddTobaccoLineButtonTitle(), for: .normal)
        addTobaccoLineButton.action = { [weak self] in
            self?.presenter.pressedAddTobaccoLine()
        }
        stackView.addArrangedSubview(addTobaccoLineButton)
    }
    private func setupAddButton() {
        addedButton.action = { [weak self] in
            guard let self else { return }
            let entity = AddManufacturerEntity.EnterData(name: self.nameTextFieldView.text,
                                                         description: self.descriptionView.text,
                                                         link: self.linkTextFieldView.text)

            self.presenter.pressedAddButton(with: entity)
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

    // MARK: - private methods
    private func changeCountryPickerView(by row: Int) {
        countryPicketView.text = presenter.receiveRowCountry(by: row)
    }

    // MARK: - Selectors

}

// MARK: - ViewInputProtocol implementation
extension AddManufacturerViewController: AddManufacturerViewInputProtocol {
    func getTobaccoLineCollectionView() -> CustomCollectionView {
        tobaccoLineCollectionView
    }

    func clearView() {
        nameTextFieldView.text = ""
        changeCountryPickerView(by: 0)
        descriptionView.text = ""
        imagePickerView.image = nil
        nameTextFieldView.becomeFirstResponderTextField()
    }

    func setupContent(_ viewModel: AddManufacturerEntity.ViewModel) {
        nameTextFieldView.text = viewModel.name
        descriptionView.text = viewModel.description
        linkTextFieldView.text = viewModel.link
        addedButton.setTitle(viewModel.textButton, for: .normal)
        addTobaccoLineButton.isEnabled = viewModel.isEnabledAddTobaccoLine
    }

    func setupImageManufacturer(_ image: Data?) {
        if let image = image {
            imagePickerView.image = UIImage(data: image)
        }
    }

    func setupSelectedCountry(_ index: Int) {
        changeCountryPickerView(by: index)
    }

    func receivedResultAddTobaccoLine(isResult: Bool) {
        if isResult {
            view.setNeedsLayout()
        }
    }
}

// MARK: - UITextFieldDelegate implementation
extension AddManufacturerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameTextFieldView.isMyTextField(textField) {
            return descriptionView.becomeFirstResponder()
        }
        return false
    }
}

// MARK: - ImagePickerViewDelegate implementation
extension AddManufacturerViewController: ImagePickerViewDelegate {
    func present(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }

    func didSelectedImage(by fileURL: URL) {
        presenter.selectedImage(with: fileURL)
    }

    func didCancel() { }
}

extension AddManufacturerViewController: AddPickerViewDelegate {
    func receiveNumberOfRows(_ pickerView: AddPickerView) -> Int {
        return presenter.numberOfRowsCountries()
    }

    func receiveRow(_ pickerView: AddPickerView, by row: Int) -> String {
        return presenter.receiveRowCountry(by: row)
    }

    func didSelected(_ pickerView: AddPickerView, by row: Int) {
        return presenter.didSelectedCounty(by: row)
    }

    func receiveIndex(_ pickerView: AddPickerView, for title: String) -> Int {
        return presenter.receiveIndexRowCountry(for: title)
    }
}

extension AddManufacturerViewController {
    var imageHeightRelativeToWidth: CGFloat { 0.5 }
}

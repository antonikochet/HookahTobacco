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

protocol AddManufacturerViewInputProtocol: AnyObject {
    func clearView()
    func setupContent(_ viewModel: AddManufacturerEntity.ViewModel)
    func setupImageManufacturer(_ image: Data?, textButton: String)
    func setupTobaccoLines()
    func setupSelectedCountry(_ index: Int)
    func receivedResultAddTobaccoLine(isResult: Bool)
    func showLoading()
    func hideLoading()
}

protocol AddManufacturerViewOutputProtocol {
    func pressedAddButton(with enteredData: AddManufacturerEntity.EnterData)
    func selectedImage(with urlFile: URL)
    func viewDidLoad()
    
    func getTobaccoLineViewModel(at index: Int) -> TasteCollectionCellViewModel
    var tobaccoLineNumberOfRows: Int { get }
    func pressedEditingTobaccoLine(at index: Int)
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
    private let tobaccoLineCollectionView = TasteCollectionView()
    private let addTobaccoLineButton = UIButton.createAppBigButton("Добавить Линейку табаков")
    private let imagePickerView = ImageButtonPickerView()
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)

    private let addedButton: UIButton = {
        let button = UIButton.createAppBigButton("Добавить нового производителя")
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return button
    }()

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        overrideUserInterfaceStyle = .light
        presenter.viewDidLoad()
        setupSubviews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addedButton.createCornerRadius()
        addTobaccoLineButton.createCornerRadius()
    }

    override func hideViewTapped() {
        super.hideViewTapped()
        countryPicketView.hideView()
    }
    // MARK: - Setups
    override func setupSubviews() {
        super.setupSubviews()

        contentScrollView.addSubview(nameTextFieldView)
        nameTextFieldView.setupView(textLabel: "Название",
                                    placeholder: "Введите название производителя...",
                                    delegate: self)
        nameTextFieldView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topSpacingFromSuperview)
            make.height.equalTo(nameTextFieldView.heightView)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }

        contentScrollView.addSubview(countryPicketView)
        countryPicketView.setupView(text: "Страна производителя")
        countryPicketView.addButtonAction = { [weak self] in
            self?.presenter.pressedAddCountry()
        }
        countryPicketView.delegate = self
        countryPicketView.snp.makeConstraints { make in
            make.top.equalTo(nameTextFieldView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }

        contentScrollView.addSubview(descriptionView)
        descriptionView.setupView(textLabel: "Описание производителя (не обязательно)")
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(countryPicketView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }

        contentScrollView.addSubview(linkTextFieldView)
        linkTextFieldView.setupView(textLabel: "Ссылка на сайт производител (не обяз.)",
                                    placeholder: "Введите ссылку",
                                    delegate: self)
        linkTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(descriptionView.snp.bottom).offset(spacingBetweenViews)
            make.height.equalTo(linkTextFieldView.heightView)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }

        let tobaccoLineBotttomView = setupAddTobaccoLineView(topView: linkTextFieldView)

        view.addSubview(addedButton)
        addedButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(spacingBetweenViews)
            make.height.equalTo(50)
        }
        addedButton.addTarget(self, action: #selector(touchAddedButton), for: .touchUpInside)

        contentScrollView.addSubview(imagePickerView)
        imagePickerView.snp.makeConstraints { make in
            make.top.equalTo(tobaccoLineBotttomView.snp.bottom).offset(spacingBetweenViews)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(spacingBetweenViews)
            make.width.greaterThanOrEqualToSuperview().dividedBy(3)
            make.width.lessThanOrEqualToSuperview().dividedBy(2)
            make.height.equalTo(imagePickerView.snp.width)
            make.bottom.equalToSuperview().inset(16.0)
        }
        imagePickerView.delegate = self

        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        activityIndicator.hidesWhenStopped = true

        setupConstrainsScrollView(top: view.safeAreaLayoutGuide,
                                  bottom: addedButton.snp.top, bottomConstant: -spacingBetweenViews)
    }

    private func setupAddTobaccoLineView(topView: UIView) -> UIView {
        contentScrollView.addSubview(tobaccoLineCollectionView)
        tobaccoLineCollectionView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).inset(-spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }
        tobaccoLineCollectionView.tasteDelegate = self
        tobaccoLineCollectionView.isUserInteractionEnabled = true

        contentScrollView.addSubview(addTobaccoLineButton)
        addTobaccoLineButton.addTarget(self, action: #selector(touchAddTobaccoLine), for: .touchUpInside)
        addTobaccoLineButton.snp.makeConstraints { make in
            make.top.equalTo(tobaccoLineCollectionView.snp.bottom).inset(-spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
            make.height.equalTo(40)
        }

        return addTobaccoLineButton
    }

    // MARK: - private methods
    private func changeCountryPickerView(by row: Int) {
        countryPicketView.text = presenter.receiveRowCountry(by: row)
    }

    // MARK: - Selectors
    @objc
    private func touchAddedButton() {
        let entity = AddManufacturerEntity.EnterData(name: nameTextFieldView.text,
                                                     description: descriptionView.text,
                                                     link: linkTextFieldView.text)

        presenter.pressedAddButton(with: entity)
    }

    @objc private func touchAddTobaccoLine() {
        presenter.pressedAddTobaccoLine()
    }
}

// MARK: - ViewInputProtocol implementation
extension AddManufacturerViewController: AddManufacturerViewInputProtocol {
    func clearView() {
        nameTextFieldView.text = ""
        changeCountryPickerView(by: 0)
        descriptionView.text = ""
        imagePickerView.image = nil
        tobaccoLineCollectionView.reloadData()
        nameTextFieldView.becomeFirstResponderTextField()
    }

    func setupContent(_ viewModel: AddManufacturerEntity.ViewModel) {
        nameTextFieldView.text = viewModel.name
        descriptionView.text = viewModel.description
        linkTextFieldView.text = viewModel.link
        tobaccoLineCollectionView.reloadData()
        addedButton.setTitle(viewModel.textButton, for: .normal)
        addTobaccoLineButton.isEnabled = viewModel.isEnabledAddTobaccoLine
        addTobaccoLineButton.alpha = viewModel.isEnabledAddTobaccoLine ? 1.0 : 0.5
    }

    func setupImageManufacturer(_ image: Data?, textButton: String) {
        if let image = image {
            imagePickerView.image = UIImage(data: image)
        }
    }

    func setupTobaccoLines() {
        tobaccoLineCollectionView.reloadData()
    }

    func setupSelectedCountry(_ index: Int) {
        changeCountryPickerView(by: index)
    }

    func receivedResultAddTobaccoLine(isResult: Bool) {
        if isResult {
            view.setNeedsLayout()
        }
    }

    func showLoading() {
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
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

extension AddManufacturerViewController: TasteCollectionViewDelegate {
    func getItem(at index: Int) -> TasteCollectionCellViewModel {
        presenter.getTobaccoLineViewModel(at: index)
    }

    var numberOfRows: Int {
        presenter.tobaccoLineNumberOfRows
    }

    func didSelectTaste(at index: Int) {
        presenter.pressedEditingTobaccoLine(at: index)
    }
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

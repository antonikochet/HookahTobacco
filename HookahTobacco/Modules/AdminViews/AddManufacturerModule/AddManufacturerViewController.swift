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
    func showAlertError(with message: String)
    func showSuccessViewAlert(_ isClear: Bool)
    func setupContent(_ viewModel: AddManufacturerEntity.ViewModel)
    func setupImageManufacturer(_ image: Data?, textButton: String)
    func showLoading()
    func hideLoading()
}

protocol AddManufacturerViewOutputProtocol {
    func pressedAddButton(with enteredData: AddManufacturerEntity.EnterData)
    func selectedImage(with urlFile: URL)
    func viewDidLoad()
}

final class AddManufacturerViewController: HTScrollContentViewController {
    // MARK: - Public properties
    var presenter: AddManufacturerViewOutputProtocol!

    override var contentViewHeight: CGFloat {
        topSpacingFromSuperview +
        nameTextFieldView.heightView +
        countryTextFieldView.heightView +
        descriptionView.heightView +
        linkTextFieldView.heightView +
        view.frame.width * imageHeightRelativeToWidth +
        spacingBetweenViews * 5
    }

    // MARK: - UI properties
    private let nameTextFieldView = AddTextFieldView()
    private let countryTextFieldView = AddTextFieldView()
    private let descriptionView = AddTextView()
    private let linkTextFieldView = AddTextFieldView()
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

        contentScrollView.addSubview(countryTextFieldView)
        countryTextFieldView.setupView(textLabel: "Страна производителя",
                                       placeholder: "Введите страну производителя",
                                       delegate: self)
        countryTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(nameTextFieldView.snp.bottom).offset(spacingBetweenViews)
            make.height.equalTo(countryTextFieldView.heightView)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }

        contentScrollView.addSubview(descriptionView)
        descriptionView.setupView(textLabel: "Описание производителя (не обязательно)")
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(countryTextFieldView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }

        contentScrollView.addSubview(linkTextFieldView)
        linkTextFieldView.setupView(textLabel: "Ссылка на сайт производител (не обяз.)",
                                    placeholder: "Введите ссылку",
                                    delegate: self)
        linkTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(descriptionView.snp.bottom).inset(-spacingBetweenViews)
            make.height.equalTo(linkTextFieldView.heightView)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }

        view.addSubview(addedButton)
        addedButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(spacingBetweenViews)
            make.height.equalTo(50)
        }
        addedButton.addTarget(self, action: #selector(touchAddedButton), for: .touchUpInside)

        contentScrollView.addSubview(imagePickerView)
        imagePickerView.snp.makeConstraints { make in
            make.top.equalTo(linkTextFieldView.snp.bottom).inset(-spacingBetweenViews)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(spacingBetweenViews)
            make.width.equalTo(imagePickerView.snp.height)
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

    // MARK: - Selectors
    @objc
    private func touchAddedButton() {
        let entity = AddManufacturerEntity.EnterData(name: nameTextFieldView.text,
                                                     country: countryTextFieldView.text,
                                                     description: descriptionView.text,
                                                     link: linkTextFieldView.text)

        presenter.pressedAddButton(with: entity)
    }
}

// MARK: - ViewInputProtocol implementation
extension AddManufacturerViewController: AddManufacturerViewInputProtocol {
    func showAlertError(with message: String) {
        showAlertError(title: "Ошибка", message: message)
    }

    func showSuccessViewAlert(_ isClear: Bool) {
        showSuccessView(duration: 0.3, delay: 2.0)
        if isClear {
            nameTextFieldView.text = ""
            countryTextFieldView.text = ""
            descriptionView.text = ""
            imagePickerView.image = nil
            nameTextFieldView.becomeFirstResponderTextField()
        }
    }

    func setupContent(_ viewModel: AddManufacturerEntity.ViewModel) {
        nameTextFieldView.text = viewModel.name
        countryTextFieldView.text = viewModel.country
        descriptionView.text = viewModel.description
        linkTextFieldView.text = viewModel.link
        addedButton.setTitle(viewModel.textButton, for: .normal)
    }

    func setupImageManufacturer(_ image: Data?, textButton: String) {
//        imagePickerView.textButton = textButton
        if let image = image {
            imagePickerView.image = UIImage(data: image)
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
            return countryTextFieldView.becomeFirstResponderTextField()
        } else if countryTextFieldView.isMyTextField(textField) {
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

extension AddManufacturerViewController {
    var imageHeightRelativeToWidth: CGFloat { 0.5 }
}

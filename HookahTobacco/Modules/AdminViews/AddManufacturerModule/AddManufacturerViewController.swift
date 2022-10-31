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

class AddManufacturerViewController: UIViewController {

    var presenter: AddManufacturerViewOutputProtocol!
    
    //MARK: ui properties
    private let nameTextFieldView = AddTextFieldView()
    
    private let countryTextFieldView = AddTextFieldView()
    
    private let descriptionView = AddTextView()
    
    private let imagePickerView = ImagePickerView()

    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    private let addedButton: UIButton = {
        let button = UIButton.createAppBigButton("Добавить нового производителя")
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return button
    }()
    
    //MARK: override viewController
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .white
        presenter.viewDidLoad()
        setupSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        addedButton.createCornerRadius()
        //Изменять код при добавление новый view
        imagePickerView.imageHeight = (addedButton.frame.minY -
                                       descriptionView.frame.maxY -
                                       imagePickerView.viewWithoutImageHeight -
                                       32)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    //MARK: setups
    private func setupSubviews() {
        view.addSubview(nameTextFieldView)
        nameTextFieldView.setupView(textLabel: "Название",
                                    placeholder: "Введите название производителя...",
                                    delegate: self)
        nameTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
            make.height.height.equalTo(nameTextFieldView.heightView)
            make.leading.trailing.equalTo(view).inset(32)
        }
        
        view.addSubview(countryTextFieldView)
        countryTextFieldView.setupView(textLabel: "Страна производителя",
                                       placeholder: "Введите страну производителя",
                                       delegate: self)
        countryTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(nameTextFieldView.snp.bottom).offset(16)
            make.height.height.equalTo(countryTextFieldView.heightView)
            make.leading.trailing.equalTo(view).inset(32)
        }
        
        view.addSubview(descriptionView)
        descriptionView.setupView(textLabel: "Описание производителя (не обязательно)")
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(countryTextFieldView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        view.addSubview(addedButton)
        addedButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            make.height.equalTo(50)
        }
        addedButton.addTarget(self, action: #selector(touchAddedButton), for: .touchUpInside)
        
        view.addSubview(imagePickerView)
        imagePickerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(descriptionView.snp.bottom).inset(-16)
        }
        imagePickerView.delegate = self
      
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        activityIndicator.hidesWhenStopped = true
    }
    
    //MARK: private methods
    @objc
    private func touchAddedButton() {
        let entity = AddManufacturerEntity.EnterData(name: nameTextFieldView.text,
                                                     country: countryTextFieldView.text,
                                                     description: descriptionView.text)
        
        presenter.pressedAddButton(with: entity)
    }
}

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
            imagePickerView.textButton = "Добавить изображение"
            nameTextFieldView.becomeFirstResponderTextField()
        }
    }
    
    func setupContent(_ viewModel: AddManufacturerEntity.ViewModel) {
        nameTextFieldView.text = viewModel.name
        countryTextFieldView.text = viewModel.country
        descriptionView.text = viewModel.description
        addedButton.setTitle(viewModel.textButton, for: .normal)
    }
    
    func setupImageManufacturer(_ image: Data?, textButton: String) {
        imagePickerView.textButton = textButton
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

extension AddManufacturerViewController: ImagePickerViewDelegate {
    func present(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }
    
    func didSelectedImage(by fileURL: URL) {
        presenter.selectedImage(with: fileURL)
    }
    
    func didCancel() {
        
    } 
}

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
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание производителя (не обязательно)"
        label.font = UIFont.appFont(size: 17, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = .black
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let text = UITextView()
        text.textColor = .black
        text.backgroundColor = UIColor(white: 0.95, alpha: 0.8)
        text.font = UIFont.appFont(size: 17, weight: .regular)
        
        return text
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        return imageView
    }()
    
    private let selectImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить изображение", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.8
        button.titleLabel?.font = UIFont.appFont(size: 17, weight: .bold)
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    //TODO: сделать переход на PHPickerView
    private var imagePickerView: UIImagePickerController?
    
    private let addedButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить нового производителя", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.8
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        button.titleLabel?.font = UIFont.appFont(size: 20, weight: .bold)
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
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.layer.borderColor = UIColor(white: 0.5, alpha: 0.2).cgColor
        descriptionTextView.layer.borderWidth = 1
        
        addedButton.layer.cornerRadius = addedButton.frame.height / 2
        addedButton.clipsToBounds = true
        
        selectImageButton.layer.cornerRadius = selectImageButton.frame.height / 2
        selectImageButton.clipsToBounds = true
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
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(countryTextFieldView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(view).inset(32)
            make.height.equalTo(30)
        }
        
        view.addSubview(descriptionTextView)
//        descriptionTextView.delegate = self
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view).inset(32)
            make.height.equalTo(200)
        }
        
        view.addSubview(addedButton)
        addedButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            make.height.equalTo(50)
        }
        addedButton.addTarget(self, action: #selector(touchAddedButton), for: .touchUpInside)
        
        view.addSubview(selectImageButton)
        selectImageButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.bottom.equalTo(addedButton.snp.top).inset(-16)
            make.height.equalTo(35)
        }
        selectImageButton.addTarget(self, action: #selector(touchSelectImageButton), for: .touchUpInside)
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionTextView.snp.bottom).inset(-32)
            make.bottom.equalTo(selectImageButton.snp.top).inset(-16)
            make.width.equalTo(imageView.snp.height)
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        activityIndicator.hidesWhenStopped = true
    }
    
    private func setupImagePickerView() {
        imagePickerView = UIImagePickerController()
        imagePickerView?.sourceType = .photoLibrary
        imagePickerView?.delegate = self
    }
    
    //MARK: private methods
    @objc
    private func touchAddedButton() {
        let entity = AddManufacturerEntity.EnterData(name: nameTextFieldView.text,
                                                     country: countryTextFieldView.text,
                                                     description: descriptionTextView.text)
        
        presenter.pressedAddButton(with: entity)
    }
    
    @objc
    private func touchSelectImageButton() {
        setupImagePickerView()
        guard let imagePickerView = imagePickerView else {
            return
        }
        present(imagePickerView, animated: true)
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
            descriptionTextView.text = ""
            imageView.image = nil
            imageView.isHidden = true
            selectImageButton.setTitle("Добавить изображение", for: .normal)
            nameTextFieldView.becomeFirstResponderTextField()
        }
    }
    
    func setupContent(_ viewModel: AddManufacturerEntity.ViewModel) {
        nameTextFieldView.text = viewModel.name
        countryTextFieldView.text = viewModel.country
        descriptionTextView.text = viewModel.description
        addedButton.setTitle(viewModel.textButton, for: .normal)
    }
    
    func setupImageManufacturer(_ image: Data?, textButton: String) {
        selectImageButton.setTitle(textButton, for: .normal)
        if let image = image {
            imageView.image = UIImage(data: image)
            imageView.isHidden = false
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
            return descriptionTextView.becomeFirstResponder()
        }
        return false
    }
}

extension AddManufacturerViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage,
              let urlImageFile = info[.imageURL] as? URL else {
            return
        }
        picker.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.presenter.selectedImage(with: urlImageFile)
            self.imageView.isHidden = false
            self.imageView.image = selectedImage
            self.imagePickerView = nil
            self.selectImageButton.setTitle("Изменить изображение", for: .normal)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

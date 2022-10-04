//
//  AddManufacturerViewController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 13.09.2022.
//

import UIKit
import SnapKit

class AddManufacturerViewController: UIViewController {

    //MARK: properties
    private let setNetworkManager: SetDataBaseNetworkingProtocol = FireBaseSetNetworkManager()
    
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
        setupSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.layer.borderColor = UIColor(white: 0.5, alpha: 0.2).cgColor
        descriptionTextView.layer.borderWidth = 1
        
        addedButton.layer.cornerRadius = addedButton.frame.height / 2
        addedButton.clipsToBounds = true

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
            make.leading.trailing.equalTo(view).inset(32)
        }
        
        view.addSubview(countryTextFieldView)
        countryTextFieldView.setupView(textLabel: "Страна производителя",
                                       placeholder: "Введите страну производителя",
                                       delegate: self)
        countryTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(nameTextFieldView.snp.bottom).offset(16)
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
    }
    
    //MARK: private methods
    @objc
    private func touchAddedButton() {
        guard let name = nameTextFieldView.text, !name.isEmpty else {
            showAlertError(title: "Ошибка", message: "Название производства не введено, поле является обязательным!")
            return
        }
        guard let country = countryTextFieldView.text, !country.isEmpty else {
            showAlertError(title: "Ошибка", message: "Страна произовдителя не введена, поле является обязательным!")
            return
        }
        let description = descriptionTextView.text
        
        let manufacturer = Manufacturer(name: name,
                                        country: country,
                                        description: description ?? "")
        
        setNetworkManager.addManufacturer(manufacturer) { [weak self] error in
            if error == nil {
                self?.showSuccessView(duration: 0.3, delay: 2.0)
                self?.nameTextFieldView.text = ""
                self?.countryTextFieldView.text = ""
                self?.descriptionTextView.text = ""
            } else {
                self?.showAlertError(title: "Ошибка", message: (error! as NSError).userInfo.description)
            }
        }
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

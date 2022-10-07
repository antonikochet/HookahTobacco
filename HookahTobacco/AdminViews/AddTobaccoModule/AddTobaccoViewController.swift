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

protocol AddTobaccoViewInputProtocol: AnyObject {
    func showAlertForUnspecifiedField(with title: String, message: String)
    func showAlertError(with message: String)
    func showSuccessViewAlert()
}

protocol AddTobaccoViewOutputProtocol: AnyObject {
    func pressedButtonAdded(with data: AddTobaccoEntity.EnteredData)
    func didSelectedManufacturer(by index: Int)
    var numberOfRows: Int { get }
    func receiveRow(by index: Int) -> String
}

class AddTobaccoViewController: UIViewController {
    var presenter: AddTobaccoViewOutputProtocol!
    
    //MARK: UI property
    private let nameView: AddTextFieldView = AddTextFieldView()
    
    private let manufacturerLabel: UILabel = {
        let label = UILabel()
        label.text = "Выбрать производителя"
        label.font = UIFont.appFont(size: 17, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = .black
        return label
    }()
    
    private let manufacturerSelectedTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.backgroundColor = UIColor(white: 0.95, alpha: 0.8)
        return textField
    }()
    
    private let manufacturerPickerView: UIPickerView = {
        let picker = UIPickerView()
        
        return picker
    }()
    
    private let tasteView: AddTextFieldView = AddTextFieldView()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание табака (не обязательно)"
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
        button.setTitle("Добавить новый табак", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.8
        button.titleLabel?.font = UIFont.appFont(size: 20, weight: .bold)
        return button
    }()
    
    //MARK: override viewController
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupSubviews()
    }
    
    //MARK: setup subviews
    private func setupSubviews() {
        view.addSubview(nameView)
        nameView.setupView(textLabel: "Название",
                           placeholder: "Введите название производителя...",
                           delegate: self)
        nameView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        setupManufacturerViews(topView: nameView)
        
        view.addSubview(tasteView)
        tasteView.setupView(textLabel: "Вкусы",
                            placeholder: "Введите вкусы табака через запятую...",
                            delegate:  self)
        tasteView.snp.makeConstraints { make in
            make.top.equalTo(manufacturerPickerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        setupDescriptionViews(topView: tasteView)
        
        view.addSubview(addedButton)
        addedButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            make.height.equalTo(50)
        }
        addedButton.addTarget(self, action: #selector(touchAddedButton), for: .touchUpInside)
    }
    
    private func setupManufacturerViews(topView: UIView) {
        view.addSubview(manufacturerLabel)
        manufacturerLabel.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        view.addSubview(manufacturerSelectedTextField)
        manufacturerSelectedTextField.delegate = self
        manufacturerSelectedTextField.snp.makeConstraints { make in
            make.top.equalTo(manufacturerLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        view.addSubview(manufacturerPickerView)
        manufacturerPickerView.delegate = self
        manufacturerPickerView.dataSource = self
        manufacturerPickerView.snp.makeConstraints { make in
            make.top.equalTo(manufacturerSelectedTextField.snp.bottom)
            make.leading.trailing.equalTo(view).inset(32)
            make.height.equalTo(0)
        }
    }
    
    private func setupDescriptionViews(topView: UIView) {
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(30)
        }
        
        view.addSubview(descriptionTextView)
//        descriptionTextView.delegate = self
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(200)
        }
    }
    
    //MARK: private methods
    @objc
    private func touchAddedButton() {
        let data = AddTobaccoEntity.EnteredData(
                        name: nameView.text,
                        tastes: tasteView.text,
                        description: descriptionTextView.text)
        presenter.pressedButtonAdded(with: data)
    }
    
    private func changeManufacturerTextField(by row: Int) {
        presenter.didSelectedManufacturer(by: row)
        manufacturerSelectedTextField.text = presenter.receiveRow(by: row)
    }
}

extension AddTobaccoViewController: AddTobaccoViewInputProtocol {
    func showAlertForUnspecifiedField(with title: String, message: String) {
        showAlertError(title: title, message: message)
    }
    
    func showAlertError(with message: String) {
        showAlertError(title: "Ошибка", message: message)
    }
    
    func showSuccessViewAlert() {
        showSuccessView(duration: 0.3, delay: 2.0)
        nameView.text = ""
        tasteView.text = ""
        descriptionTextView.text = ""
        changeManufacturerTextField(by: 0)
    }
}

extension AddTobaccoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == manufacturerSelectedTextField {
            manufacturerPickerView.isHidden = false
            manufacturerPickerView.snp.updateConstraints { make in
                make.height.equalTo(120)
            }
            textField.endEditing(true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameView.isMyTextField(textField) {
            return tasteView.becomeFirstResponderTextField()
        } else if tasteView.isMyTextField(textField) {
            return descriptionTextView.becomeFirstResponder()
        }
        return false
    }
}

extension AddTobaccoViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return presenter.numberOfRows
    }
}

extension AddTobaccoViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return presenter.receiveRow(by: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        changeManufacturerTextField(by: row)
        self.manufacturerPickerView.isHidden = true
        self.manufacturerPickerView.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
    }
}

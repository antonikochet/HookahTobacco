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
    func showAlertError(with message: String)
    func showSuccessViewAlert(_ isClear: Bool)
    func setupContent(_ viewModel: AddTobaccoEntity.ViewModel)
    func setupSelectedManufacturer(_ index: Int)
    func setupMainImage(_ image: Data?, textButton: String)
    func showLoading()
    func hideLoading()
}

protocol AddTobaccoViewOutputProtocol: AnyObject {
    func pressedButtonAdded(with data: AddTobaccoEntity.EnteredData)
    func didSelectedManufacturer(by index: Int)
    func didSelectMainImage(with imageURL: URL)
    var numberOfRows: Int { get }
    func receiveRow(by index: Int) -> String
    func receiveIndexRow(for title: String) -> Int
    func viewDidLoad()
}

class AddTobaccoViewController: UIViewController {
    var presenter: AddTobaccoViewOutputProtocol!
    
    //MARK: UI property
    private let nameView: AddTextFieldView = AddTextFieldView()
    
    private let manufacturerPickerView = AddPickerView()
    
    private let tasteView: AddTextFieldView = AddTextFieldView()
    
    private let descriptionView = AddTextView()
    
    private let imagePickerView = ImagePickerView()
    
    private let addedButton = UIButton.createAppBigButton()
    
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    //MARK: override viewController
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupSubviews()
        presenter.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        addedButton.createCornerRadius()
        imagePickerView.imageHeight = (addedButton.frame.minY -
                                       descriptionView.frame.maxY -
                                       imagePickerView.viewWithoutImageHeight -
                                       32)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
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
            make.height.equalTo(nameView.heightView)
        }
        
        view.addSubview(manufacturerPickerView)
        manufacturerPickerView.setupView(text: "Выбрать производителя табака")
        manufacturerPickerView.delegate = self
        manufacturerPickerView.snp.makeConstraints { make in
            make.top.equalTo(nameView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        view.addSubview(tasteView)
        tasteView.setupView(textLabel: "Вкусы",
                            placeholder: "Введите вкусы табака через запятую...",
                            delegate:  self)
        tasteView.snp.makeConstraints { make in
            make.top.equalTo(manufacturerPickerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(tasteView.heightView)
        }
        
        view.addSubview(descriptionView)
        descriptionView.setupView(textLabel: "Описание табака (не обязательно)")
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(tasteView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        view.addSubview(addedButton)
        addedButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
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
        let data = AddTobaccoEntity.EnteredData(
                        name: nameView.text,
                        tastes: tasteView.text,
                        description: descriptionView.text)
        presenter.pressedButtonAdded(with: data)
    }
    
    private func changeManufacturerPickerView(by row: Int) {
        manufacturerPickerView.text = presenter.receiveRow(by: row)
    }
}

extension AddTobaccoViewController: AddTobaccoViewInputProtocol {
    func showAlertError(with message: String) {
        showAlertError(title: "Ошибка", message: message)
    }
    
    func showSuccessViewAlert(_ isClear: Bool) {
        showSuccessView(duration: 0.3, delay: 2.0)
        if isClear {
            nameView.text = ""
            tasteView.text = ""
            descriptionView.text = ""
            changeManufacturerPickerView(by: 0)
            nameView.becomeFirstResponderTextField()
            imagePickerView.textButton = "Добавить изображение"
            imagePickerView.image = nil
        }
    }
    
    func setupContent(_ viewModel: AddTobaccoEntity.ViewModel) {
        nameView.text = viewModel.name
        tasteView.text = viewModel.tastes
        descriptionView.text = viewModel.description
        addedButton.setTitle(viewModel.textButton, for: .normal)
    }
    
    func setupSelectedManufacturer(_ index: Int) {
        changeManufacturerPickerView(by: index)
    }
    
    func setupMainImage(_ image: Data?, textButton: String) {
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

extension AddTobaccoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameView.isMyTextField(textField) {
            return tasteView.becomeFirstResponderTextField()
        } else if tasteView.isMyTextField(textField) {
            return descriptionView.becomeFirstResponder()
        }
        return false
    }
}

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

extension AddTobaccoViewController: AddPickerViewDelegate {
    var pickerNumberOfRows: Int {
        presenter.numberOfRows
    }
    
    func receiveRow(by row: Int) -> String {
        presenter.receiveRow(by: row)
    }
    
    func didSelected(by row: Int) {
        presenter.didSelectedManufacturer(by: row)
    }
    
    func receiveIndex(for title: String) -> Int {
        presenter.receiveIndexRow(for: title)
    }
}

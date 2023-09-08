//
//  AddPickerView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 28.10.2022.
//

import UIKit
import SnapKit

protocol AddPickerViewDelegate: AnyObject {
    func receiveNumberOfRows(_ pickerView: AddPickerView) -> Int
    func receiveRow(_ pickerView: AddPickerView, by row: Int) -> String
    func didSelected(_ pickerView: AddPickerView, by row: Int)
    func receiveIndex(_ pickerView: AddPickerView, for title: String) -> Int
}

class AddPickerView: UIView {
    // MARK: public properties
    weak var delegate: AddPickerViewDelegate?

    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    var pickerViewHeight: CGFloat = 120

    var addButtonAction: CompletionBlock?

    // MARK: private properties

    private let isAddButton: Bool

    var viewHeight: CGFloat {
        label.intrinsicContentSize.height + 4 + 34
    }

    private let label = UILabel()
    private let textField = UITextField()
    private let pickerView = UIPickerView()
    private lazy var addButton = IconButton()

    // MARK: init
    init(isAddButton: Bool = false) {
        self.isAddButton = isAddButton
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: public methods
    func setupView(text: String) {
        label.text = text
        snp.updateConstraints { make in
            make.height.equalTo(viewHeight)
        }
    }

    func showView() {
        pickerView.snp.updateConstraints { make in
            make.height.equalTo(pickerViewHeight)
        }
        snp.updateConstraints { make in
            make.height.equalTo(viewHeight + pickerViewHeight)
        }
    }

    func hideView() {
        pickerView.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
        snp.updateConstraints { make in
            make.height.equalTo(viewHeight)
        }
    }

    // MARK: private methods
    private func setupUI() {
        setupLabel()
        setupTextField()
        if isAddButton {
            setupAddButton()
        }
        setupPickerView()
        snp.makeConstraints { make in
            make.height.equalTo(viewHeight)
        }
    }
    private func setupLabel() {
        label.setForTitleName()
        addSubview(label)
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(label.font.lineHeight)
        }
    }
    private func setupTextField() {
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.backgroundColor = R.color.inputBackground()
        textField.textColor = R.color.primaryBlack()
        addSubview(textField)
        textField.delegate = self
        textField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(4)
            make.leading.equalToSuperview()
            if !isAddButton {
                make.trailing.equalToSuperview()
            }
        }
    }
    private func setupAddButton() {
        addButton.action = { [weak self] in
            self?.addButtonAction?()
        }
        addButton.image = R.image.add()
        addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.leading.equalTo(textField.snp.trailing).offset(8)
            make.centerY.equalTo(textField.snp.centerY)
            make.trailing.equalToSuperview()
        }
    }
    private func setupPickerView() {
        addSubview(pickerView)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
        }
    }

    private func showSelected() {
        guard let title = textField.text,
              let index = delegate?.receiveIndex(self, for: title) else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.pickerView.selectRow(index, inComponent: 0, animated: true)
        }
    }

    @objc private func touchAddButton() {
        addButtonAction?()
    }
}

extension AddPickerView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.textField,
           delegate?.receiveNumberOfRows(self) ?? 0 > 1 {
            showView()
            showSelected()
        }
        textField.endEditing(true)
    }
}

extension AddPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return delegate?.receiveNumberOfRows(self) ?? 0
    }
}

extension AddPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return delegate?.receiveRow(self, by: row)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didSelected(self, by: row)
        text = delegate?.receiveRow(self, by: row)
        hideView()
    }
}

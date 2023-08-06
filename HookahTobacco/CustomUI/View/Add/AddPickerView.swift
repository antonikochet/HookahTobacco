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

    var addButtonAction: (() -> Void)?

    // MARK: private properties

    private let isAddButton: Bool

    private let label: UILabel = {
        let label = UILabel()
        return label
    }()

    var viewHeight: CGFloat {
        label.font.lineHeight + 16 + 31
    }

    private let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.backgroundColor = UIColor(white: 0.95, alpha: 0.8)
        return textField
    }()

    private let pickerView = UIPickerView()

    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle.fill")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = .systemGreen
        return button
    }()

    // MARK: init
    init(isAddButton: Bool = false) {
        self.isAddButton = isAddButton
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        self.isAddButton = false
        super.init(coder: coder)
        setup()
    }

    // MARK: public methods
    func setupView(text: String) {
        label.text = text
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
    private func setup() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(label.font.lineHeight)
        }

        addSubview(textField)
        textField.delegate = self
        textField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(16)
            make.leading.equalToSuperview()
            if !isAddButton {
                make.trailing.equalToSuperview()
            }
            make.height.equalTo(31)
        }

        if isAddButton {
            addSubview(addButton)
            addButton.snp.makeConstraints { make in
                make.leading.equalTo(textField.snp.trailing).offset(4)
                make.centerY.equalTo(textField.snp.centerY)
                make.size.equalTo(CGSize(width: 24, height: 24))
                make.trailing.equalToSuperview()
            }
            addButton.addTarget(self, action: #selector(touchAddButton), for: .touchUpInside)
        }

        addSubview(pickerView)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
        }

        snp.makeConstraints { make in
            make.height.equalTo(viewHeight)
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

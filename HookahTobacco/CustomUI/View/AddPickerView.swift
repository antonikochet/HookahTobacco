//
//  AddPickerView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 28.10.2022.
//

import UIKit
import SnapKit

protocol AddPickerViewDelegate: AnyObject {
    var pickerNumberOfRows: Int { get }
    func receiveRow(by row: Int) -> String
    func didSelected(by row: Int)
    func receiveIndex(for title: String) -> Int
}

class AddPickerView: UIView {
    // MARK: public properties
    weak var delegate: AddPickerViewDelegate?

    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    var pickerViewHeight: CGFloat = 120

    // MARK: private properties
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

    // MARK: init
    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: public methods
    func setupView(text: String) {
        label.text = text
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
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(31)
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

    private func showSelectedManufacturer() {
        guard let title = textField.text,
              let index = delegate?.receiveIndex(for: title) else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.pickerView.selectRow(index, inComponent: 0, animated: true)
        }
    }
}

extension AddPickerView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.textField {
            pickerView.snp.updateConstraints { make in
                make.height.equalTo(pickerViewHeight)
            }
            snp.updateConstraints { make in
                make.height.equalTo(viewHeight + pickerViewHeight)
            }
            showSelectedManufacturer()
            textField.endEditing(true)
        }
    }
}

extension AddPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return delegate?.pickerNumberOfRows ?? 0
    }
}

extension AddPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return delegate?.receiveRow(by: row)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didSelected(by: row)
        text = delegate?.receiveRow(by: row)
        self.pickerView.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
        snp.updateConstraints { make in
            make.height.equalTo(viewHeight)
        }
    }
}

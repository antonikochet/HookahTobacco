//
//  AddTextFieldView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 15.09.2022.
//

import UIKit
import SnapKit

class AddTextFieldView: UIView {

    // MARK: public properties
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: .greatestFiniteMagnitude, height: (label.intrinsicContentSize.height +
                                                         4.0 +
                                                         textField.intrinsicContentSize.height)
        )
    }
    // MARK: private properties UI
    private let label = UILabel()
    private let textField = UITextField()

    // MARK: init
    init() {
        super.init(frame: .zero)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }

    // MARK: public methods
    func setupView(textLabel: String, placeholder: String, delegate: UITextFieldDelegate? = nil) {
        label.text = textLabel
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: R.color.secondarySubtitle() ?? .systemGray5]
        )
        textField.delegate = delegate
    }

    func isMyTextField(_ textField: UITextField) -> Bool {
        textField == self.textField
    }

    @discardableResult
    func becomeFirstResponderTextField() -> Bool {
        textField.becomeFirstResponder()
    }

    // MARK: - Public methods
    func enableTextField() {
        textField.isEnabled = true
        textField.alpha = 1.0
    }

    func disableTextField() {
        textField.isEnabled = false
        textField.alpha = 0.5
    }

    func setTextContentType(_ textContentType: UITextContentType) {
        textField.textContentType = textContentType
    }

    func setKeyboardType(_ keyboardType: UIKeyboardType) {
        textField.keyboardType = keyboardType
    }
    func setIsSecureTextEntry(_ isSecureTextEntry: Bool) {
        textField.isSecureTextEntry = isSecureTextEntry
    }

    // MARK: private methods
    private func setupSubviews() {
        addSubview(label)
        addSubview(textField)

        label.setForTitleName()
        label.snp.makeConstraints { make in
            make.top.equalTo(snp.top)
            make.leading.trailing.equalTo(self)
        }

        textField.textColor = R.color.primaryBlack()
        textField.tintColor = R.color.primaryBlack()
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .next
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.backgroundColor = R.color.inputBackground()
        textField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(4)
            make.leading.trailing.equalTo(self)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
}

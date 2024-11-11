//
//  AddTextFieldView.swift
//  
//
//  Created by антон кочетков on 15.09.2022.
//

import UIKit
import SnapKit
import HookahTobaccoResources

public final class AddTextFieldView: UIView {
    // MARK: - Public properties
    public var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    public override var intrinsicContentSize: CGSize {
        CGSize(width: .greatestFiniteMagnitude,
               height: (
                titleLabel.intrinsicContentSize.height +
                4.0 +
                LayoutValues.textFieldHeight +
                (errorLabel.isHidden ? 0 : LayoutValues.errorLabelTop) +
                (errorLabel.isHidden ? 0 : errorLabel.intrinsicContentSize.height)
               )
        )
    }

    // MARK: - Private properties

    // MARK: - Private UI
    private let titleLabel = UILabel()
    private let textField = UITextField()
    private let errorLabel = UILabel()

    // MARK: - Init
    public init() {
        super.init(frame: .zero)
        setupUI()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup UI
    private func setupUI() {
        setupTitleLabel()
        setupTextField()
        setupErrorLabel()
    }
    private func setupTitleLabel() {
        titleLabel.setForTitleName()
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    private func setupTextField() {
        textField.textColor = ResourceManager.provider.color(forKey: .primaryBlack).colorUIKit
        textField.tintColor = ResourceManager.provider.color(forKey: .primaryBlack).colorUIKit
        textField.font = UIFont.appFont(size: 16.0, weight: .medium)
        textField.clearButtonMode = .whileEditing
        textField.textAlignment = .left
        textField.returnKeyType = .next
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.createPaddingView(LayoutValues.textFieldPadding, in: .left, with: .always)
        textField.createPaddingView(LayoutValues.textFieldPadding, in: .right, with: .always)
        textField.backgroundColor = ResourceManager.provider.color(forKey: .inputBackground).colorUIKit
        textField.layer.cornerRadius = 8.0
        textField.clipsToBounds = true
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(LayoutValues.textFieldHeight)
        }
    }
    private func setupErrorLabel() {
        errorLabel.font = UIFont.appFont(size: 14.0, weight: .medium)
        errorLabel.textColor = ResourceManager.provider.color(forKey: .primaryRed).colorUIKit
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .left
        errorLabel.isHidden = true
        addSubview(errorLabel)
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(LayoutValues.errorLabelTop)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview()
        }
    }

    // MARK: - Public methods
    public func setupView(textLabel: String, placeholder: String, delegate: UITextFieldDelegate? = nil) {
        titleLabel.text = textLabel
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: ResourceManager.provider.color(forKey: .secondarySubtitle).colorUIKit ?? .systemGray5]
        )
        textField.delegate = delegate
    }

    public func setError(message: String?) {
        errorLabel.text = message
        errorLabel.isHidden = message == nil
        textField.textColor = ResourceManager.provider.color(forKey: message == nil ? .primaryBlack : .primaryRed).colorUIKit
    }

    public func isMyTextField(_ textField: UITextField) -> Bool {
        textField == self.textField
    }

    @discardableResult
    public func becomeFirstResponderTextField() -> Bool {
        textField.becomeFirstResponder()
    }

    public func enableTextField() {
        textField.isEnabled = true
        textField.alpha = 1.0
    }

    public func disableTextField() {
        textField.isEnabled = false
        textField.alpha = 0.5
    }

    public func setTextContentType(_ textContentType: UITextContentType) {
        textField.textContentType = textContentType
    }

    public func setTextAlignmentTextField(_ textAlignment: NSTextAlignment) {
        textField.textAlignment = textAlignment
    }

    public func setKeyboardType(_ keyboardType: UIKeyboardType) {
        textField.keyboardType = keyboardType
    }

    public func setIsSecureTextEntry(_ isSecureTextEntry: Bool) {
        textField.isSecureTextEntry = isSecureTextEntry
    }

    // MARK: - Private methods

    // MARK: - Selectors

}

private struct LayoutValues {
    static let textFieldPadding: CGFloat = 12.0
    static let textFieldHeight: CGFloat = 40.0
    static let errorLabelTop: CGFloat = 2.0
}

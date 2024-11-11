//
//  TextFieldWithLeftLabel.swift
//
//
//  Created by Anton Kochetkov on 11.09.2023.
//

import UIKit
import SnapKit
import HookahTobaccoResources

extension TextFieldWithLeftLabel {
    public enum Rounding {
        case up
        case down

        fileprivate var maskedCorners: CACornerMask {
            switch self {
            case .down:
                return [.layerMaxXMaxYCorner]
            case .up:
                return [.layerMaxXMinYCorner]
            }
        }
    }
    public enum TextFieldType {
        case text
        case email
        case password

        fileprivate var keyboardType: UIKeyboardType {
            switch self {
            case .text, .password: return .default
            case .email: return .emailAddress
            }
        }
    }
}

public final class TextFieldWithLeftLabel: UIView {

    // MARK: - Public properties
    public var text: String? {
        get {
            textField.text
        }
        set {
            textField.text = newValue
        }
    }

    public var didBeginEditing: VoidBlock?
    public var didEndEditing: VoidBlock?
    public var shouldBeginEditing: (() -> Bool)?
    public var shouldEndEditing: (() -> Bool)?

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: .greatestFiniteMagnitude,
                      height: (LayoutValues.textFieldHeight +
                               (errorLabel.isHidden ? 0 : LayoutValues.errorLabelTop) +
                               (errorLabel.isHidden ? 0 : errorLabel.intrinsicContentSize.height)))
    }

    // MARK: - Private properties
    private var rounding: Rounding
    private var type: TextFieldType

    // MARK: - Private UI
    private let titleLabel = UILabel()
    private let textField = UITextField()
    private let errorLabel = UILabel()

    // MARK: - Init
    public init(rounding: Rounding, type: TextFieldType) {
        self.rounding = rounding
        self.type = type
        super.init(frame: .zero)
        setupUI()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        setupView()
        setupTitleLabel()
        setupTextField()
        setupErrorLabel()
    }
    private func setupView() {
        backgroundColor = .clear
    }
    private func setupTitleLabel() {
        titleLabel.font = UIFont.appFont(size: 16.0, weight: .medium)
        titleLabel.textColor = ResourceManager.provider.color(forKey: .secondarySubtitle).colorUIKit
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left
    }
    private func setupTextField() {
        textField.textColor = ResourceManager.provider.color(forKey: .primaryBlack).colorUIKit 
        textField.tintColor = ResourceManager.provider.color(forKey: .primaryBlack).colorUIKit
        textField.backgroundColor = ResourceManager.provider.color(forKey: .inputBackground).colorUIKit
        textField.keyboardType = type.keyboardType
        textField.clearButtonMode = .whileEditing
        textField.textAlignment = .right
        textField.leftView = titleLabel
        textField.leftViewMode = .always
        textField.createPaddingView(LayoutValues.textFieldPadding, in: .right, with: .always)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.delegate = self
        setupRoundingTextField()
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
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
    public func setupView(title: String, placeholder: String? = nil) {
        titleLabel.text = "   \(title)"
        textField.placeholder = placeholder
    }

    public func setError(message: String?) {
        errorLabel.text = message
        errorLabel.isHidden = message == nil
        textField.textColor = message == nil ? ResourceManager.provider.color(forKey: .primaryBlack).colorUIKit : ResourceManager.provider.color(forKey: .primaryRed).colorUIKit
    }

    public func setRounding(_ rounding: Rounding) {
        self.rounding = rounding
        setupRoundingTextField()
    }

    // MARK: - Private methods
    private func setupRoundingTextField() {
        textField.isSecureTextEntry = type == .password
        textField.textContentType = .oneTimeCode
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 19.0
        textField.layer.maskedCorners = rounding.maskedCorners
    }
    // MARK: - Selectors

}

extension TextFieldWithLeftLabel: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        setError(message: nil)
        textField.createPaddingView(LayoutValues.textFieldPadding, in: .left, with: .always)
        textField.textAlignment = .left
        didBeginEditing?()
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.leftView = titleLabel
        textField.textAlignment = .right
        didEndEditing?()
    }

    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return shouldEndEditing?() ?? true
    }

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return shouldBeginEditing?() ?? true
    }
}

private struct LayoutValues {
    static let textFieldPadding: CGFloat = 16.0
    static let textFieldHeight: CGFloat = 46.0
    static let errorLabelTop: CGFloat = 2.0
}

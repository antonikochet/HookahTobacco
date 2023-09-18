//
//  AddTextView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 28.10.2022.
//

import UIKit
import SnapKit

class AddTextView: UIView {
    // MARK: - Public properties
    var text: String! {
        get { textView.text }
        set { textView.text = newValue }
    }

    var heightTextView: CGFloat = 160 {
        didSet {
            textView.snp.updateConstraints { make in
                make.height.equalTo(heightTextView)
            }
        }
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: .greatestFiniteMagnitude,
               height: (
                titleLabel.intrinsicContentSize.height +
                4 +
                heightTextView +
                (errorLabel.isHidden ? 0 : LayoutValues.errorLabelTop) +
                (errorLabel.isHidden ? 0 : errorLabel.intrinsicContentSize.height))
        )
    }

    // MARK: - Private UI
    private let titleLabel = UILabel()
    private let textView = UITextView()
    private let errorLabel = UILabel()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup UI
    private func setupUI() {
        setupTitleLabel()
        setupTextView()
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
    private func setupTextView() {
        textView.backgroundColor = R.color.inputBackground()
        textView.textColor = R.color.primaryBlack()
        textView.tintColor = R.color.primaryBlack()
        textView.font = UIFont.appFont(size: 16, weight: .regular)
        textView.layer.cornerRadius = 10
        textView.textContainerInset = UIEdgeInsets(horizontal: 8, vertical: 4)
        addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(heightTextView)
        }
    }
    private func setupErrorLabel() {
        errorLabel.font = UIFont.appFont(size: 14.0, weight: .medium)
        errorLabel.textColor = R.color.primaryRed()
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .left
        errorLabel.isHidden = true
        addSubview(errorLabel)
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(LayoutValues.errorLabelTop)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview()
        }
    }

    // MARK: public methods
    func setupView(textLabel: String, delegate: UITextViewDelegate? = nil) {
        titleLabel.text = textLabel
        textView.delegate = delegate
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        textView.becomeFirstResponder()
    }

    func setError(message: String?) {
        errorLabel.text = message
        errorLabel.isHidden = message == nil
    }
}

private struct LayoutValues {
    static let errorLabelTop: CGFloat = 2.0
}

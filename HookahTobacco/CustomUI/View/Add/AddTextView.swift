//
//  AddTextView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 28.10.2022.
//

import UIKit
import SnapKit

class AddTextView: UIView {
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
        return CGSize(width: .greatestFiniteMagnitude,
                      height: label.intrinsicContentSize.height + 8 + heightTextView)
    }

    private let label = UILabel()
    private let textView = UITextView()

    init() {
        super.init(frame: .zero)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }

    // MARK: public methods
    func setupView(textLabel: String, delegate: UITextViewDelegate? = nil) {
        label.text = textLabel
        textView.delegate = delegate
    }

    // MARK: private methods
    private func setupSubviews() {
        addSubview(label)
        addSubview(textView)

        label.setForTitleName()
        label.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }

        textView.backgroundColor = R.color.inputBackground()
        textView.textColor = R.color.primaryBlack()
        textView.tintColor = R.color.primaryBlack()
        textView.font = UIFont.appFont(size: 17, weight: .regular)
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = R.color.primaryTitle()?.withAlphaComponent(0.7).cgColor
        textView.layer.borderWidth = 1
        textView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(heightTextView)
        }
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        textView.becomeFirstResponder()
    }
}

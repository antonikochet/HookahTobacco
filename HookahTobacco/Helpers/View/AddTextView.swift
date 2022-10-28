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
            snp.updateConstraints { make in
                make.height.equalTo(heightView)
            }
        }
    }
    
    private var heightView: CGFloat {
        heightTextView +
        label.font.lineHeight +
        8
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private let textView: UITextView = {
        let text = UITextView()
        text.textColor = .black
        text.backgroundColor = UIColor(white: 0.95, alpha: 0.8)
        text.font = UIFont.appFont(size: 17, weight: .regular)
        return text
    }()
    
    init() {
        super.init(frame: .zero)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    //MARK: public methods
    func setupView(textLabel: String, delegate: UITextViewDelegate? = nil) {
        label.text = textLabel
        textView.delegate = delegate
    }
    
    //MARK: private methods
    private func setupSubviews() {
        addSubview(label)
        addSubview(textView)
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(label.font.lineHeight)
        }

        textView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(heightTextView)
        }
        
        snp.makeConstraints { make in
            make.height.equalTo(heightView)
        }
        
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = UIColor(white: 0.5, alpha: 0.2).cgColor
        textView.layer.borderWidth = 1
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        textView.becomeFirstResponder()
    }
}

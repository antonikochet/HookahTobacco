//
//  AddTextFieldView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 15.09.2022.
//

import UIKit
import SnapKit

class AddTextFieldView: UIView {
    
    //MARK: public properties
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    var heightView: CGFloat {
        label.font.lineHeight + 8 + 31
    }
    
    //MARK: private properties UI
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private let textField: UITextField = {
        let text = UITextField()
        text.textColor = .black
        text.borderStyle = .roundedRect
        text.clearButtonMode = .whileEditing
        text.returnKeyType = .next
        text.autocorrectionType = .no
        text.backgroundColor = UIColor(white: 0.95, alpha: 0.8)
        return text
    }()
    
    //MARK: init
    init() {
        super.init(frame: .zero)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    //MARK: public methods
    func setupView(textLabel: String, placeholder: String, delegate: UITextFieldDelegate? = nil) {
        label.text = textLabel
        textField.placeholder = placeholder
        textField.delegate = delegate
    }
    
    func isMyTextField(_ textField: UITextField) -> Bool {
        textField == self.textField
    }
    
    @discardableResult
    func becomeFirstResponderTextField() -> Bool {
        textField.becomeFirstResponder()
    }
    
    //MARK: private methods
    private func setupSubviews() {
        addSubview(label)
        addSubview(textField)
        
        label.snp.makeConstraints { make in
            make.top.equalTo(snp.top)
            make.leading.trailing.equalTo(self)
        }

        textField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.leading.trailing.equalTo(self)
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(31)
        }
    }
}

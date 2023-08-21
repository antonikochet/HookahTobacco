//
//  AddSwitchView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 02.12.2022.
//

import UIKit
import SnapKit

class AddSwitchView: UIView {
    // MARK: - Public properties
    var heightView: CGFloat {
        switchView.frame.height
    }

    var isOn: Bool {
        switchView.isOn
    }

    var didChangeSwitch: ((Bool) -> Void)?

    // MARK: - Private UI
    private let label: UILabel = {
        let label = UILabel()
        return label
    }()

    private let switchView: UISwitch = {
        let switchView = UISwitch()
        switchView.isOn = false
        return switchView
    }()

    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }

    // MARK: - Setups
    private func setupSubviews() {
        addSubview(label)
        addSubview(switchView)

        label.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(0)
        }

        switchView.addTarget(self, action: #selector(didChangeSwitchValue), for: .valueChanged)
        switchView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(label.snp.trailing).offset(8)
            make.trailing.bottom.equalToSuperview()
        }
    }

    // MARK: - Public methods
    func setupView(textLabel: String, isOn: Bool) {
        label.text = textLabel
        label.snp.updateConstraints { make in
            make.width.equalTo(textLabel.sizeOfString(usingFont: label.font).width)
        }
        switchView.isOn = isOn
    }

    // MARK: - Selectors
    @objc private func didChangeSwitchValue() {
        didChangeSwitch?(switchView.isOn)
    }
}

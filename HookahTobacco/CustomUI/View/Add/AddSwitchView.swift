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
    private let label = UILabel()
    private let switchView = UISwitch()

    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setups
    private func setupSubviews() {
        addSubview(label)
        addSubview(switchView)

        label.setForTitleName()
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.trailing.equalTo(switchView.snp.leading).inset(8.0)
        }

        switchView.isOn = false
        switchView.onTintColor = R.color.primaryGreen()
        switchView.tintColor = R.color.fourthBackground()
        switchView.addTarget(self, action: #selector(didChangeSwitchValue), for: .valueChanged)
        switchView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
        }
    }

    // MARK: - Public methods
    func setupView(textLabel: String, isOn: Bool) {
        label.text = textLabel
        switchView.isOn = isOn
    }

    // MARK: - Selectors
    @objc private func didChangeSwitchValue() {
        didChangeSwitch?(switchView.isOn)
    }
}

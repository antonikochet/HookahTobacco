//
//  AddParamTobaccoView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 01.12.2022.
//

import UIKit
import SnapKit

class AddParamTobaccoView: UIView {
    // MARK: - Public properties
    var heightView: CGFloat {
        topMargin + packetingFormatsView.heightView +
        topMargin + tobaccoTypeView.heightView +
        topMargin + baseSwitchView.heightView +
        topMargin
    }

    var packetingFormatsText: String? {
        packetingFormatsView.text
    }
    var selectedTobaccoTypeIndex: Int {
        tobaccoTypeView.selectedIndex
    }
    var isOn: Bool {
        baseSwitchView.isOn
    }

    // MARK: - Private properties
    private let topMargin: CGFloat = 8.0

    // MARK: - Private UI
    private let packetingFormatsView = AddTextFieldView()
    private let tobaccoTypeView = AddSegmentedControlView()
    private let baseSwitchView = AddSwitchView()

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
        addSubview(packetingFormatsView)
        addSubview(tobaccoTypeView)
        addSubview(baseSwitchView)

        packetingFormatsView.setupView(textLabel: "Вес упаковок",
                                       placeholder: "Введите вес через запятую",
                                       delegate: self)

        packetingFormatsView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topMargin)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(packetingFormatsView.heightView)
        }
        tobaccoTypeView.snp.makeConstraints { make in
            make.top.equalTo(packetingFormatsView.snp.bottom).offset(topMargin)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(tobaccoTypeView.heightView)
        }
        baseSwitchView.snp.makeConstraints { make in
            make.top.equalTo(tobaccoTypeView.snp.bottom).offset(topMargin)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(baseSwitchView.heightView)
        }

        snp.makeConstraints { $0.height.equalTo(heightView) }
    }

    // MARK: - Public methods
    func setupView(packetingFormats: String,
                   tobaccoTypes: [String],
                   selectedTobaccoTypeIndex: Int,
                   isBaseLine: Bool) {
        packetingFormatsView.text = packetingFormats
        tobaccoTypeView.setupView(textLabel: "Тип табака", segmentTitles: tobaccoTypes)
        tobaccoTypeView.selectedIndex = selectedTobaccoTypeIndex
        baseSwitchView.setupView(textLabel: "Базовая линейка: ", isOn: isBaseLine)
    }

    func showView() {
        isHidden = false
        snp.updateConstraints { make in
            make.height.equalTo(heightView)
        }
    }

    func hideView() {
        isHidden = true
        endEditing(true)
        snp.updateConstraints { make in
            make.height.equalTo(0)
        }
    }
}

extension AddParamTobaccoView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
}

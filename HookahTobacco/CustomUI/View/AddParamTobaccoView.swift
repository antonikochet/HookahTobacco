//
//  AddParamTobaccoView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 01.12.2022.
//

import UIKit
import SnapKit

protocol AddParamTobaccoViewModelProtocol {
    var packetingFormats: String { get }
    var tobaccoTypes: [String] { get }
    var selectedTobaccoTypeIndex: Int { get }
    var isBaseLine: Bool { get }
    var tobaccoLeafTypes: [String] { get }
    var selectedTobaccoLeafTypeIndex: [Int] { get }
}

class AddParamTobaccoView: UIView {
    // MARK: - Public properties
    var heightView: CGFloat {
        topMargin + packetingFormatsView.heightView +
        topMargin + tobaccoTypeView.heightView +
        topMargin + baseSwitchView.heightView +
        (tobaccoLeafTypeView.isHidden ? 0 : topMargin + tobaccoLeafTypeView.heightView) +
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
    var selectedTobaccoLeafTypeIndexs: [Int] {
        tobaccoLeafTypeView.selectedIndex
    }

    // MARK: - Private properties
    private let topMargin: CGFloat = 8.0

    // MARK: - Private UI
    private let packetingFormatsView = AddTextFieldView()
    private let tobaccoTypeView = AddSegmentedControlView()
    private let baseSwitchView = AddSwitchView()
    private let tobaccoLeafTypeView = AddMultiSegmentedControlView()

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
        addSubview(tobaccoLeafTypeView)

        packetingFormatsView.setupView(textLabel: "Вес упаковок",
                                       placeholder: "Введите вес через запятую",
                                       delegate: self)
        tobaccoTypeView.delegate = self

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
        tobaccoLeafTypeView.snp.makeConstraints { make in
            make.top.equalTo(baseSwitchView.snp.bottom).offset(topMargin)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(tobaccoLeafTypeView.heightView)
        }

        snp.makeConstraints { $0.height.equalTo(heightView) }
    }

    // MARK: - Public methods
    func setupView(_ viewModel: AddParamTobaccoViewModelProtocol) {
        packetingFormatsView.text = viewModel.packetingFormats
        tobaccoTypeView.setupView(textLabel: "Тип табака", segmentTitles: viewModel.tobaccoTypes)
        tobaccoTypeView.selectedIndex = viewModel.selectedTobaccoTypeIndex
        baseSwitchView.setupView(textLabel: "Базовая линейка: ", isOn: viewModel.isBaseLine)
        tobaccoLeafTypeView.setupView(textLabel: "Типы листа табака", segmentTitles: viewModel.tobaccoLeafTypes)
        tobaccoLeafTypeView.selectedIndex = viewModel.selectedTobaccoLeafTypeIndex
        defineHiddenTobaccoLeafView(index: viewModel.selectedTobaccoTypeIndex)
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

    // MARK: - Private methods
    private func defineHiddenTobaccoLeafView(index: Int) {
        if index == 0 {
            tobaccoLeafTypeView.showView()
        } else {
            tobaccoLeafTypeView.hideView()
        }
        snp.updateConstraints { make in
            make.height.equalTo(isHidden ? 0 : heightView)
        }
        superview?.setNeedsLayout()
    }
}

extension AddParamTobaccoView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
}

extension AddParamTobaccoView: AddSegmentedControlViewDelegate {
    func didTouchSegmentedControl(_ view: AddSegmentedControlView, touchIndex: Int) {
        defineHiddenTobaccoLeafView(index: touchIndex)
    }
}

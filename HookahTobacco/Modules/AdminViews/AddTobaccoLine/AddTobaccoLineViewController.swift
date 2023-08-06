//
//
//  AddTobaccoLineViewController.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 04.08.2023.
//
//

import UIKit
import SnapKit

protocol AddTobaccoLineViewInputProtocol: AnyObject {
    func setupView(_ viewModel: AddTobaccoLineEntity.EnterData)
    func showLoading()
    func hideLoading()
}

protocol AddTobaccoLineViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func pressedDoneButton(_ viewModel: AddTobaccoLineEntity.ViewModel)
    func pressedCloseButton()
}

class AddTobaccoLineViewController: UIViewController {
    // MARK: - Public properties
    var presenter: AddTobaccoLineViewOutputProtocol!

    // MARK: - Private properties
    private let sidePadding: CGFloat = 16.0
    private let topMargin: CGFloat = 8.0

    // MARK: - UI properties
    private let nameView = AddTextFieldView()
    private let packetingFormatsView = AddTextFieldView()
    private let tobaccoTypeView = AddSegmentedControlView()
    private let baseSwitchView = AddSwitchView()
    private let tobaccoLeafTypeView = AddMultiSegmentedControlView()
    private let descriptionView = AddTextView()
    private let doneButton = UIButton.createAppBigButton("Готово", fontSise: 24)
    private let closeButton = IconButton()
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        doneButton.createCornerRadius()
    }

    // MARK: - Setups
    private func setupUI() {
        setupView()
        setupCloseButton()
        setupNameView()
        setupPacketingFormatsView()
        setupTobaccoTypeView()
        setupBaseSwitchView()
        setupTobaccoLeafTypeView()
        setupDescriptionView()
        setupDoneButton()
        setupActivityIndicator()
    }
    private func setupView() {
        view.backgroundColor = .white
    }
    private func setupCloseButton() {
        closeButton.action = { [weak self] in
            self?.presenter.pressedCloseButton()
        }
        closeButton.buttonSize = 36.0
        closeButton.backgroundColor = .systemGray3
        closeButton.image = UIImage(systemName: "multiply")
        closeButton.imageColor = .white
        closeButton.createCornerRadius()
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(sidePadding)
        }
    }
    private func setupNameView() {
        view.addSubview(nameView)
        nameView.setupView(textLabel: "Название линейки",
                           placeholder: "Введите название линейки",
                           delegate: self)
        nameView.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(topMargin)
            make.leading.trailing.equalToSuperview().inset(sidePadding)
            make.height.equalTo(nameView.heightView)
        }
    }
    private func setupPacketingFormatsView() {
        view.addSubview(packetingFormatsView)
        packetingFormatsView.setupView(textLabel: "Вес упаковок",
                                       placeholder: "Введите вес через запятую",
                                       delegate: self)
        packetingFormatsView.snp.makeConstraints { make in
            make.top.equalTo(nameView.snp.bottom).offset(topMargin)
            make.leading.trailing.equalToSuperview().inset(sidePadding)
            make.height.equalTo(packetingFormatsView.heightView)
        }
    }
    private func setupTobaccoTypeView() {
        view.addSubview(tobaccoTypeView)
        tobaccoTypeView.delegate = self
        tobaccoTypeView.snp.makeConstraints { make in
            make.top.equalTo(packetingFormatsView.snp.bottom).offset(topMargin)
            make.leading.trailing.equalToSuperview().inset(sidePadding)
            make.height.equalTo(tobaccoTypeView.heightView)
        }
    }
    private func setupBaseSwitchView() {
        view.addSubview(baseSwitchView)
        baseSwitchView.didChangeSwitch = { [weak self] isOn in
            guard let self else { return }
            if isOn { nameView.disableTextField() } else { nameView.enableTextField() }
        }
        baseSwitchView.snp.makeConstraints { make in
            make.top.equalTo(tobaccoTypeView.snp.bottom).offset(topMargin)
            make.leading.trailing.equalToSuperview().inset(sidePadding)
            make.height.equalTo(baseSwitchView.heightView)
        }
    }
    private func setupTobaccoLeafTypeView() {
        view.addSubview(tobaccoLeafTypeView)

        tobaccoLeafTypeView.snp.makeConstraints { make in
            make.top.equalTo(baseSwitchView.snp.bottom).offset(topMargin)
            make.leading.trailing.equalToSuperview().inset(sidePadding)
            make.height.equalTo(tobaccoLeafTypeView.heightView)
        }
    }
    private func setupDescriptionView() {
        view.addSubview(descriptionView)
        descriptionView.heightTextView = 120
        descriptionView.setupView(textLabel: "Описание")
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(tobaccoLeafTypeView.snp.bottom).offset(topMargin)
            make.leading.trailing.equalToSuperview().inset(sidePadding)
        }
    }
    private func setupDoneButton() {
        view.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(touchDone), for: .touchUpInside)
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionView.snp.bottom).offset(sidePadding)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
        }
    }
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        activityIndicator.hidesWhenStopped = true
    }
    // MARK: - Private methods
    private func defineHiddenTobaccoLeafView(index: Int) {
        if index == 0 {
            tobaccoLeafTypeView.showView()
        } else {
            tobaccoLeafTypeView.hideView()
        }
    }

    // MARK: - Selectors
    @objc private func touchDone() {
        presenter.pressedDoneButton(AddTobaccoLineEntity.ViewModel(
            name: nameView.text ?? "",
            packetingFormats: packetingFormatsView.text ?? "",
            selectedTobaccoTypeIndex: tobaccoTypeView.selectedIndex,
            description: descriptionView.text ?? "",
            isBase: baseSwitchView.isOn,
            selectedTobaccoLeafTypeIndexs: tobaccoLeafTypeView.selectedIndex
        ))
    }
}

// MARK: - ViewInputProtocol implementation
extension AddTobaccoLineViewController: AddTobaccoLineViewInputProtocol {
    func setupView(_ viewModel: AddTobaccoLineEntity.EnterData) {
        nameView.text = viewModel.name
        packetingFormatsView.text = viewModel.packetingFormats
        tobaccoTypeView.setupView(textLabel: "Тип табака", segmentTitles: viewModel.tobaccoTypes)
        tobaccoTypeView.selectedIndex = viewModel.selectedTobaccoTypeIndex
        baseSwitchView.setupView(textLabel: "Базовая линейка: ", isOn: viewModel.isBaseLine)
        if viewModel.isBaseLine { nameView.disableTextField() } else { nameView.enableTextField() }
        tobaccoLeafTypeView.setupView(textLabel: "Типы листа табака", segmentTitles: viewModel.tobaccoLeafTypes)
        tobaccoLeafTypeView.selectedIndex = viewModel.selectedTobaccoLeafTypeIndex
        defineHiddenTobaccoLeafView(index: viewModel.selectedTobaccoTypeIndex)
        descriptionView.text = viewModel.description
    }

    func showLoading() {
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
    }
}

// MARK: - UITextFieldDelegate implementation
extension AddTobaccoLineViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameView.isMyTextField(textField) {
            view.endEditing(true)
        }
        return false
    }
}

// MARK: - AddSegmentedControlViewDelegate implementation
extension AddTobaccoLineViewController: AddSegmentedControlViewDelegate {
    func didTouchSegmentedControl(_ view: AddSegmentedControlView, touchIndex: Int) {
        defineHiddenTobaccoLeafView(index: touchIndex)
    }
}

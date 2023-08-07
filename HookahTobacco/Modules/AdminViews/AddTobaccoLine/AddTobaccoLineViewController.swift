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

protocol AddTobaccoLineViewInputProtocol: ViewProtocol {
    func setupView(_ viewModel: AddTobaccoLineEntity.EnterData)
}

protocol AddTobaccoLineViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func pressedDoneButton(_ viewModel: AddTobaccoLineEntity.ViewModel)
    func pressedCloseButton()
}
// FIXME: - поправить верстку при открытие клавиатуры
class AddTobaccoLineViewController: HTScrollContentViewController, BottomSheetPresenter {

    // MARK: - BottomSheetPresenter properties
    var dismissOnPull: Bool = false
    var dismissOnOverlayTap: Bool = false
    var isShowGrip: Bool = false

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
    private let doneButton = ApplyButton()
    private let closeButton = IconButton()

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        presenter.viewDidLoad()
    }

    // MARK: - Setups
    override func setupSubviews() {
        super.setupSubviews()
        setupView()
        setupCloseButton()
        setupNameView()
        setupPacketingFormatsView()
        setupTobaccoTypeView()
        setupBaseSwitchView()
        setupTobaccoLeafTypeView()
        setupDescriptionView()
        setupDoneButton()
        setupConstrainsScrollView(top: view.safeAreaLayoutGuide.snp.top,
                                  bottom: doneButton.snp.top,
                                  bottomConstant: -spacingBetweenViews)
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
        contentScrollView.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(sidePadding)
        }
    }
    private func setupNameView() {
        contentScrollView.addSubview(nameView)
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
        contentScrollView.addSubview(packetingFormatsView)
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
        contentScrollView.addSubview(tobaccoTypeView)
        tobaccoTypeView.delegate = self
        tobaccoTypeView.snp.makeConstraints { make in
            make.top.equalTo(packetingFormatsView.snp.bottom).offset(topMargin)
            make.leading.trailing.equalToSuperview().inset(sidePadding)
            make.height.equalTo(tobaccoTypeView.heightView)
        }
    }
    private func setupBaseSwitchView() {
        contentScrollView.addSubview(baseSwitchView)
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
        contentScrollView.addSubview(tobaccoLeafTypeView)

        tobaccoLeafTypeView.snp.makeConstraints { make in
            make.top.equalTo(baseSwitchView.snp.bottom).offset(topMargin)
            make.leading.trailing.equalToSuperview().inset(sidePadding)
            make.height.equalTo(tobaccoLeafTypeView.heightView)
        }
    }
    private func setupDescriptionView() {
        contentScrollView.addSubview(descriptionView)
        descriptionView.heightTextView = 120
        descriptionView.setupView(textLabel: "Описание", delegate: self)
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(tobaccoLeafTypeView.snp.bottom).offset(topMargin)
            make.leading.trailing.equalToSuperview().inset(sidePadding)
            make.bottom.equalToSuperview()
        }
    }
    private func setupDoneButton() {
        doneButton.setTitle("Готово", for: .normal)
        doneButton.action = { [weak self] in
            guard let self else { return }
            self.presenter.pressedDoneButton(AddTobaccoLineEntity.ViewModel(
                name: self.nameView.text ?? "",
                packetingFormats: self.packetingFormatsView.text ?? "",
                selectedTobaccoTypeIndex: self.tobaccoTypeView.selectedIndex,
                description: self.descriptionView.text ?? "",
                isBase: self.baseSwitchView.isOn,
                selectedTobaccoLeafTypeIndexs: self.tobaccoLeafTypeView.selectedIndex
            ))
        }
        view.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(contentScrollView.snp.bottom).offset(sidePadding)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.bottom.equalToSuperview().inset(32.0)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - Private methods
    private func defineHiddenTobaccoLeafView(index: Int) {
        if index == 0 {
            tobaccoLeafTypeView.showView()
        } else {
            tobaccoLeafTypeView.hideView()
        }
        sheetViewController?.updateIntrinsicHeight()
    }

    private func updateBottomDoneButtonConstraint(_ offset: CGFloat) {
        doneButton.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(offset)
        }
    }

    // MARK: - Selectors

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
}

// MARK: - UITextFieldDelegate implementation
extension AddTobaccoLineViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameView.isMyTextField(textField) {
            return packetingFormatsView.becomeFirstResponderTextField()
        } else if packetingFormatsView.isMyTextField(textField) {
            return view.endEditing(true)
        }
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateBottomDoneButtonConstraint(4.0)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        updateBottomDoneButtonConstraint(32.0)
    }
}

// MARK: - UITextViewDelegate implementation
extension AddTobaccoLineViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        setOffset(CGPoint(x: 0, y: descriptionView.heightTextView))
        updateBottomDoneButtonConstraint(4.0)
        print(contentScrollView.frame)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        setOffset(.zero)
        updateBottomDoneButtonConstraint(32.0)
        print(contentScrollView.frame)
    }
}

// MARK: - AddSegmentedControlViewDelegate implementation
extension AddTobaccoLineViewController: AddSegmentedControlViewDelegate {
    func didTouchSegmentedControl(_ view: AddSegmentedControlView, touchIndex: Int) {
        defineHiddenTobaccoLeafView(index: touchIndex)
    }
}

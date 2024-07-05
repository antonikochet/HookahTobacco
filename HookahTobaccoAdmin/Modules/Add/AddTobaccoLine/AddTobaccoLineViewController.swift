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

    // MARK: - UI properties
    private let nameView = AddTextFieldView()
    private let packetingFormatsView = AddTextFieldView()
    private let tobaccoTypeView = AddSegmentedControlView()
    private let baseSwitchView = AddSwitchView()
    private let tobaccoLeafTypeView = AddMultiSegmentedControlView()
    private let descriptionView = AddTextView()
    private let doneButton = ApplyButton(style: .primary)
    private let closeButton = IconButton()

    override var stackViewInset: UIEdgeInsets {
        UIEdgeInsets(horizontal: 16.0, vertical: 16.0)
    }

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
                                  bottomConstant: -16.0)
    }
    private func setupView() {
        view.backgroundColor = R.color.primaryBackground()
        stackView.spacing = 8.0
    }
    private func setupCloseButton() {
        let view = UIView()
        stackView.addArrangedSubview(view)

        closeButton.action = { [weak self] in
            self?.presenter.pressedCloseButton()
        }
        closeButton.size = 36.0
        closeButton.imageSize = 36.0
        closeButton.image = R.image.close()
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(8.0)
            make.bottom.equalToSuperview().inset(8.0)
        }
    }
    private func setupNameView() {
        stackView.addArrangedSubview(nameView)
        nameView.setupView(textLabel: R.string.localizable.addTobaccoLineNameTextFieldTitle(),
                           placeholder: R.string.localizable.addTobaccoLineNameTextFieldPlaceholder(),
                           delegate: self)
    }
    private func setupPacketingFormatsView() {
        stackView.addArrangedSubview(packetingFormatsView)
        packetingFormatsView.setupView(
            textLabel: R.string.localizable.addTobaccoLinePacketingFormatsTextFieldTitle(),
            placeholder: R.string.localizable.addTobaccoLinePacketingFormatsTextFieldPlaceholder(),
            delegate: self
        )
    }
    private func setupTobaccoTypeView() {
        stackView.addArrangedSubview(tobaccoTypeView)
        tobaccoTypeView.didTouchSegmentedControl = { [weak self] index in
            self?.defineHiddenTobaccoLeafView(index: index)
        }
    }
    private func setupBaseSwitchView() {
        stackView.addArrangedSubview(baseSwitchView)
        baseSwitchView.didChangeSwitch = { [weak self] isOn in
            guard let self else { return }
            if isOn { nameView.disableTextField() } else { nameView.enableTextField() }
        }
    }
    private func setupTobaccoLeafTypeView() {
        stackView.addArrangedSubview(tobaccoLeafTypeView)
    }
    private func setupDescriptionView() {
        stackView.addArrangedSubview(descriptionView)
        descriptionView.heightTextView = 120
        descriptionView.setupView(textLabel: R.string.localizable.addTobaccoLineDescriptionTitle(), delegate: self)
    }
    private func setupDoneButton() {
        doneButton.setTitle(R.string.localizable.addTobaccoLineAddButtonTitle(), for: .normal)
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
            make.top.equalTo(contentScrollView.snp.bottom).offset(16.0)
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
        tobaccoTypeView.setupView(
            textLabel: R.string.localizable.addTobaccoLineTypeTitle(),
            segmentTitles: viewModel.tobaccoTypes)
        tobaccoTypeView.selectedIndex = viewModel.selectedTobaccoTypeIndex
        baseSwitchView.setupView(
            textLabel: R.string.localizable.addTobaccoLineSwitchTitle(),
            isOn: viewModel.isBaseLine)
        if viewModel.isBaseLine { nameView.disableTextField() } else { nameView.enableTextField() }
        tobaccoLeafTypeView.setupView(
            textLabel: R.string.localizable.addTobaccoLineTypeLeafTitle(),
            segmentTitles: viewModel.tobaccoLeafTypes)
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

//
//  AddTobaccoLineView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 29.11.2022.
//

import UIKit
import SnapKit

protocol AddTobaccoLineViewViewModelProtocol {
    var name: String? { get }
    var packetingFormats: String? { get }
    var tobaccoTypes: [String] { get }
    var selectedTobaccoTypeIndex: Int { get }
    var description: String? { get }
    var isBase: Bool { get }
}

protocol AddTobaccoLineViewDelegate: AnyObject {
    func didTouchDone(name: String,
                      packetingFormats: String,
                      selectedTobaccoTypeIndex: Int,
                      description: String,
                      isBase: Bool)
    func didTouchClose()
}

class AddTobaccoLineView: UIView {

    // MARK: - Public properties
    weak var delegate: AddTobaccoLineViewDelegate?

    var heightView: CGFloat {
        topMargin + nameView.heightView +
        topMargin + paramTobaccoView.heightView +
        topMargin + descriptionView.heightView +
        topMargin + doneButton.frame.height +
        topMargin
    }

    // MARK: - Private properties
    private let sidePadding: CGFloat = 16.0
    private let topMargin: CGFloat = 8.0

    // MARK: - Private UI
    private let nameView = AddTextFieldView()
    private let paramTobaccoView = AddParamTobaccoView()
    private let descriptionView = AddTextView()
    private let closeButton = UIButton.createAppBigButton(image: UIImage(systemName: "xmark")?
                                                                    .withRenderingMode(.alwaysTemplate),
                                                          backgroundColor: .systemGray3)
    private let doneButton = UIButton.createAppBigButton("Готово", fontSise: 24)

    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        closeButton.createCornerRadius()
        doneButton.createCornerRadius()
    }

    // MARK: Public methods
    func setupView(_ viewModel: AddTobaccoLineViewViewModelProtocol) {
        nameView.text = viewModel.name
        paramTobaccoView.setupView(packetingFormats: viewModel.packetingFormats ?? "",
                                   tobaccoTypes: viewModel.tobaccoTypes,
                                   selectedTobaccoTypeIndex: viewModel.selectedTobaccoTypeIndex,
                                   isBaseLine: viewModel.isBase)
        descriptionView.text = viewModel.description
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
    private func setupSubviews() {
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor(white: 0.6, alpha: 0.5).cgColor
        clipsToBounds = true
        backgroundColor = UIColor(white: 0.98, alpha: 0.9)

        addSubview(nameView)
        addSubview(paramTobaccoView)
        addSubview(descriptionView)
        addSubview(closeButton)
        addSubview(doneButton)

        nameView.setupView(textLabel: "Название линейки",
                           placeholder: "Введите название линейки",
                           delegate: self)
        descriptionView.heightTextView = 120
        descriptionView.setupView(textLabel: "Описание")
        closeButton.tintColor = .white
        doneButton.addTarget(self, action: #selector(touchDone), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(touchClose), for: .touchUpInside)

        nameView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topMargin)
            make.leading.trailing.equalToSuperview().inset(sidePadding)
            make.height.equalTo(nameView.heightView)
        }
        paramTobaccoView.snp.makeConstraints { make in
            make.top.equalTo(nameView.snp.bottom).offset(topMargin)
            make.leading.trailing.equalToSuperview().inset(sidePadding)
            make.height.equalTo(paramTobaccoView.heightView)
        }
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(paramTobaccoView.snp.bottom).offset(topMargin)
            make.leading.trailing.equalToSuperview().inset(sidePadding)
        }
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionView.snp.bottom).offset(topMargin)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(topMargin)
        }
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }

        snp.makeConstraints { make in
            make.height.equalTo(0)
        }
    }

    // MARK: - Selectors
    @objc private func touchDone() {
        delegate?.didTouchDone(name: nameView.text ?? "",
                               packetingFormats: paramTobaccoView.packetingFormatsText ?? "",
                               selectedTobaccoTypeIndex: paramTobaccoView.selectedTobaccoTypeIndex,
                               description: descriptionView.text ?? "",
                               isBase: paramTobaccoView.isOn)
    }

    @objc private func touchClose() {
        delegate?.didTouchClose()
    }
}

extension AddTobaccoLineView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameView.isMyTextField(textField) {
            endEditing(true)
        }
        return false
    }
}

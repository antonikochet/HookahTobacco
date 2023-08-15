//
//
//  DatePickerViewController.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 15.08.2023.
//
//

import UIKit
import SnapKit

protocol DatePickerViewInputProtocol: AnyObject {
    func setupView(valueData: Date, title: String?, minDate: Date?, maxDate: Date?)
}

protocol DatePickerViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func changedDateOnPicker(_ newDate: Date)
    func pressedChooseButton()
}

class DatePickerViewController: UIViewController, BottomSheetPresenter {
    // MARK: - BottomSheetPresenter
    var isShowGrip: Bool = false
    var dismissOnPull: Bool = false

    // MARK: - Public properties
    var presenter: DatePickerViewOutputProtocol!

    // MARK: - UI properties
    private let titleLabel = UILabel()
    private let chooseButton = UIButton(type: .system)
    private let pickerView = UIDatePicker()

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter.viewDidLoad()
    }

    // MARK: - Setups
    private func setupUI() {
        setupView()
        setupLabelView()
        setupChooseButton()
        setupPickerView()
    }
    private func setupView() {

    }
    private func setupLabelView() {
        titleLabel.font = UIFont.appFont(size: 20.0, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left

        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16.0)
            make.top.equalToSuperview().offset(22.0)
        }
    }
    private func setupChooseButton() {
        chooseButton.titleLabel?.font = UIFont.appFont(size: 16.0, weight: .regular)
        chooseButton.setTitleColor(.orange, for: .normal)
        chooseButton.setTitle("Выбрать", for: .normal)
        chooseButton.addTarget(self,
                             action: #selector(chooseDate),
                             for: .touchUpInside)
        
        view.addSubview(chooseButton)
        chooseButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16.0)
            make.top.equalToSuperview().offset(22.0)
        }
    }
    private func setupPickerView() {
        pickerView.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        pickerView.datePickerMode = .date
        if #available(iOS 13.4, *) {
            pickerView.preferredDatePickerStyle = .wheels
        }
        view.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(22.0)
        }
    }
    // MARK: - Private methods

    // MARK: - Selectors
    @objc private func datePickerChanged() {
        presenter.changedDateOnPicker(pickerView.date)
    }

    @objc private func chooseDate() {
        presenter.pressedChooseButton()
    }
}

// MARK: - ViewInputProtocol implementation
extension DatePickerViewController: DatePickerViewInputProtocol {
    func setupView(valueData: Date, title: String?, minDate: Date?, maxDate: Date?) {
        titleLabel.text = title
        pickerView.date = valueData
        pickerView.minimumDate = minDate
        pickerView.maximumDate = maxDate
    }
}

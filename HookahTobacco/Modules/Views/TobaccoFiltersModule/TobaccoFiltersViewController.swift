//
//
//  TobaccoFiltersViewController.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 29.08.2023.
//
//

import UIKit
import SnapKit
import FittedSheets

protocol TobaccoFiltersViewInputProtocol: ViewProtocol {
    func getTableView() -> UITableView
    func updateCounter(_ text: String?)
    func getCloseButton() -> UIView
}

protocol TobaccoFiltersViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func touchAllClearButton()
    func touchApplyButton()
    func touchCloseButton()
}

class TobaccoFiltersViewController: BaseViewController, BottomSheetPresenter {
    // MARK: - BottomSheetPresenter
    var sizes: [SheetSize] = [.marginFromTop(50.0)]
    var isShowGrip: Bool = false

    // MARK: - Public properties
    var presenter: TobaccoFiltersViewOutputProtocol!

    // MARK: - UI properties
    private let closeButton = Button(style: .third)
    private let tableView = UITableView()
    private let counterLabel = UILabel()
    private let applyButton = ApplyButton(style: .primary)
    private let clearAllButton = Button(style: .third)

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter.viewDidLoad()
    }

    // MARK: - Setups
    private func setupUI() {
        setupView()
        setupClearAllButton()
        setupApplyButton()
        setupCloseButton()
        setupCounterLabel()
        setupTableView()
    }
    private func setupView() {
        view.backgroundColor = R.color.primaryBackground()
    }
    private func setupClearAllButton() {
        clearAllButton.action = { [weak self] in
            self?.presenter.touchAllClearButton()
        }
        clearAllButton.setTitle(R.string.localizable.generalAllClear())
        view.addSubview(clearAllButton)
        clearAllButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8.0)
        }
    }
    private func setupApplyButton() {
        applyButton.action = { [weak self] in
            self?.presenter.touchApplyButton()
        }
        applyButton.setTitle(R.string.localizable.tobaccoFilterApplyButtonTitle(), for: .normal)
        applyButton.backgroundColor = R.color.primaryPurple()
        applyButton.setTitleColor(.white, for: .normal)
        view.addSubview(applyButton)
        applyButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(36.0)
            make.bottom.equalTo(clearAllButton.snp.top).inset(-8.0)
        }
    }
    private func setupCounterLabel() {
        counterLabel.font = UIFont.appFont(size: 14.0, weight: .regular)
        counterLabel.textColor = R.color.primaryTitle()
        counterLabel.textAlignment = .center
        counterLabel.numberOfLines = 1
        view.addSubview(counterLabel)
        counterLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.bottom.equalTo(applyButton.snp.top).offset(-8.0)
        }
    }
    private func setupCloseButton() {
        closeButton.setTitle(R.string.localizable.generalClose())
        closeButton.action = { [weak self] in
            self?.presenter.touchCloseButton()
        }
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8.0)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8.0)
        }
    }
    private func setupTableView() {
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(closeButton.snp.bottom).offset(16.0)
            make.bottom.equalTo(counterLabel.snp.top).offset(-16.0)
        }
    }
    // MARK: - Private methods

    // MARK: - Selectors

}

// MARK: - ViewInputProtocol implementation
extension TobaccoFiltersViewController: TobaccoFiltersViewInputProtocol {
    func getTableView() -> UITableView {
        tableView
    }

    func updateCounter(_ text: String?) {
        counterLabel.text = text
    }

    func getCloseButton() -> UIView {
        closeButton
    }
}

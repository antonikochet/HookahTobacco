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
    var sizes: [SheetSize] = [.fullscreen]
    // MARK: - Public properties
    var presenter: TobaccoFiltersViewOutputProtocol!

    // MARK: - UI properties
    private let closeButton = UIButton()
    private let tableView = UITableView()
    private let counterLabel = UILabel()
    private let applyButton = ApplyButton()
    private let clearAllButton = ApplyButton()

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter.viewDidLoad()
    }

    // MARK: - Setups
    private func setupUI() {
        setupClearAllButton()
        setupApplyButton()
        setupCloseButton()
        setupCounterLabel()
        setupTableView()
    }
    private func setupClearAllButton() {
        clearAllButton.action = { [weak self] in
            self?.presenter.touchAllClearButton()
        }
        clearAllButton.setTitle("Очистить все", for: .normal)
        clearAllButton.backgroundColor = .clear
        clearAllButton.titleLabel?.font = UIFont.appFont(size: 18.0, weight: .medium)
        clearAllButton.setTitleColor(.blue, for: .normal)
        view.addSubview(clearAllButton)
        clearAllButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8.0)
            make.size.equalTo(CGSize(width: 150, height: 22))
        }
    }
    private func setupApplyButton() {
        applyButton.action = { [weak self] in
            self?.presenter.touchApplyButton()
        }
        applyButton.setTitle("Применить фильтры", for: .normal)
        applyButton.backgroundColor = .blue
        applyButton.setTitleColor(.white, for: .normal)
        view.addSubview(applyButton)
        applyButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(36.0)
            make.bottom.equalTo(clearAllButton.snp.top).inset(-8.0)
        }
    }
    private func setupCounterLabel() {
        counterLabel.font = UIFont.appFont(size: 16.0, weight: .regular)
        counterLabel.textColor = .black
        counterLabel.textAlignment = .center
        counterLabel.numberOfLines = 1
        view.addSubview(counterLabel)
        counterLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.bottom.equalTo(applyButton.snp.top).offset(-8.0)
        }
    }
    private func setupCloseButton() {
        closeButton.setTitle("Закрыть", for: .normal)
        closeButton.setTitleColor(.blue, for: .normal)
        closeButton.backgroundColor = .clear
        closeButton.addTarget(self, action: #selector(touchCloseButton), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8.0)
            make.width.equalTo(80)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8.0)
        }
    }
    private func setupTableView() {
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(closeButton.snp.bottom).offset(16.0)
            make.bottom.equalTo(counterLabel.snp.top).offset(-16.0)
        }
    }
    // MARK: - Private methods

    // MARK: - Selectors
    @objc private func touchCloseButton() {
        presenter.touchCloseButton()
    }
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
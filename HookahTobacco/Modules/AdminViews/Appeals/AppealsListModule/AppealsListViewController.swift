//
//
//  AppealsListViewController.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 19.09.2023.
//
//

import UIKit
import SnapKit

protocol AppealsListViewInputProtocol: ViewProtocol {
    func getTableView() -> UITableView
    func getThemesCollectionView() -> CustomCollectionView
    func clearStatus()
}

protocol AppealsListViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func didSelectStatus(by index: Int)
    func pressedApplyButton()
    func pressedClearButton()
}

class AppealsListViewController: BaseViewController {
    // MARK: - Public properties
    var presenter: AppealsListViewOutputProtocol!

    // MARK: - UI properties
    private let filterContainer = UIView()
    private let themesFilterTitle = UILabel()
    private let themesFilterCollectionView = CustomCollectionView()
    private let statusSegmentedControlView = AddSegmentedControlView()
    private let applyFilterButton = Button(style: .fill)
    private let clearFilterButton = Button(style: .secondary)
    private let showFilterButton = IconButton()
    private let tableView = UITableView()

    private var topTableViewConstraint: Constraint!

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }

    // MARK: - Setups
    private func setupUI() {
        setupScreen()
        setupFilterContainer()
        setupThemesTitleLabel()
        setupThemesFilterCollectionView()
        setupStatusSegmentedControlView()
        setupApplyFilterButton()
        setupClearFilterButton()
        setupTableView()
        setupShowFilterButton()
    }
    private func setupScreen() {
        view.backgroundColor = R.color.primaryBackground()
        navigationItem.title = R.string.localizable.appealsListTitle()
    }
    private func setupFilterContainer() {
        filterContainer.backgroundColor = R.color.secondaryBackground()
        filterContainer.isHidden = true
        filterContainer.layer.cornerRadius = 16.0
        filterContainer.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.addSubview(filterContainer)
        filterContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
    }
    private func setupThemesTitleLabel() {
        themesFilterTitle.setForTitleName()
        themesFilterTitle.text = R.string.localizable.appealsListFilterThemeTitle()
        filterContainer.addSubview(themesFilterTitle)
        themesFilterTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    private func setupThemesFilterCollectionView() {
        filterContainer.addSubview(themesFilterCollectionView)
        themesFilterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(themesFilterTitle.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    private func setupStatusSegmentedControlView() {
        statusSegmentedControlView.setupView(textLabel: R.string.localizable.appealsListFilterStatusTitle(),
                                             segmentTitles: AppealStatus.allCases.map { $0.title })
        statusSegmentedControlView.didTouchSegmentedControl = { [weak self] index in
            self?.presenter.didSelectStatus(by: index)
        }
        filterContainer.addSubview(statusSegmentedControlView)
        statusSegmentedControlView.snp.makeConstraints { make in
            make.top.equalTo(themesFilterCollectionView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    private func setupApplyFilterButton() {
        applyFilterButton.setTitle(R.string.localizable.appealsListFilterApplyTitle())
        applyFilterButton.action = { [weak self] in
            self?.presenter.pressedApplyButton()
        }
        filterContainer.addSubview(applyFilterButton)
        applyFilterButton.snp.makeConstraints { make in
            make.top.equalTo(statusSegmentedControlView.snp.bottom).offset(8)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    private func setupClearFilterButton() {
        clearFilterButton.setTitle(R.string.localizable.appealsListFilterClearTitle())
        clearFilterButton.action = { [weak self] in
            self?.presenter.pressedClearButton()
        }
        filterContainer.addSubview(clearFilterButton)
        clearFilterButton.snp.makeConstraints { make in
            make.centerY.equalTo(applyFilterButton)
            make.trailing.equalTo(applyFilterButton.snp.leading).inset(-16.0)
        }
    }
    private func setupTableView() {
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 20
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).priority(.medium)
            topTableViewConstraint = make.top.equalTo(filterContainer.snp.bottom).offset(8).constraint
            make.leading.trailing.bottom.equalToSuperview()
        }
        topTableViewConstraint.deactivate()
    }
    private func setupShowFilterButton() {
        showFilterButton.imageSize = 18.0
        showFilterButton.size = 20
        showFilterButton.image = R.image.chevronDown()
        showFilterButton.backgroundColor = R.color.thirdBackground()
        showFilterButton.createCornerRadius()
        showFilterButton.action = { [weak self] in
            guard let self else { return }
            let isDown = !self.filterContainer.isHidden
            self.filterContainer.isHidden.toggle()
            self.topTableViewConstraint.isActive.toggle()
            self.showFilterButton.image = isDown ? R.image.chevronDown() : R.image.chevronUp()
        }
        view.addSubview(showFilterButton)
        showFilterButton.snp.makeConstraints { make in
            make.top.equalTo(tableView)
            make.trailing.equalToSuperview().inset(8)
        }
    }
    // MARK: - Private methods

    // MARK: - Selectors

}

// MARK: - ViewInputProtocol implementation
extension AppealsListViewController: AppealsListViewInputProtocol {
    func getTableView() -> UITableView {
        tableView
    }

    func getThemesCollectionView() -> CustomCollectionView {
        themesFilterCollectionView
    }

    func clearStatus() {
        statusSegmentedControlView.selectedIndex = -1
    }
}

//
//
//  TobaccoFiltersPresenter.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 29.08.2023.
//
//

import Foundation
import TableKit
import UIKit

class TobaccoFiltersPresenter {
    // MARK: - Public properties
    weak var view: TobaccoFiltersViewInputProtocol!
    var interactor: TobaccoFiltersInteractorInputProtocol!
    var router: TobaccoFiltersRouterProtocol!

    // MARK: - Private properties
    private var tableDirector: TableDirector?
    private var filters: TobaccoFilters = TobaccoFilters()
    private var selectedFilters: TobaccoFilters = TobaccoFilters()
    private var isDownloadData: Bool = false
    private weak var timer: Timer?

    // MARK: - Private methods
    // swiftlint:disable:next function_body_length
    private func setupContent(_ filters: TobaccoFilters) {
        guard let tableDirector else { return }
        tableDirector.clear()

        var rows: [Row] = []

        // manufacturer
        if !filters.manufacturer.isEmpty {
            let selectedIds = Set(selectedFilters.manufacturer.map { $0.id })
            let items = filters.manufacturer.map {
                FilterTobaccoCollectionViewCellItem(label: $0.name, isSelect: selectedIds.contains($0.id))
            }
            let item = CategoriesTobaccoFiltersViewCellTableViewCellItem(
                title: "Производители",
                items: items,
                didSelect: { [weak self] index in
                    guard let self else { return }
                    let manufacturer = self.filters.manufacturer[index]
                    if let index = self.selectedFilters.manufacturer.firstIndex(where: { $0.id == manufacturer.id }) {
                        self.selectedFilters.manufacturer.remove(at: index)
                    } else {
                        self.selectedFilters.manufacturer.append(manufacturer)
                    }
                    self.reloadFilters()
                    self.initializeTimer()
                },
                clearAction: { [weak self] in
                    guard let self else { return }
                    self.selectedFilters.manufacturer = []
                    self.updateFilter()
                })
            let row = TableRow<CategoriesTobaccoFiltersViewCellTableViewCell>(item: item)
            rows.append(row)
        }

        // tobaccoType
        if !filters.tobaccoType.isEmpty {
            let selectedIds = selectedFilters.tobaccoType.map { $0.rawValue }
            let item = MultiSegmentedTobaccoTableViewCellItem(
                title: "Тип табака",
                itemsSegment: TobaccoType.allCases.map { $0.name },
                selectItems: selectedIds) { [weak self] index in
                    guard let self,
                          let tobaccoType = TobaccoType.allCases.first(where: { $0.rawValue == index })
                    else { return }
                    if selectedFilters.tobaccoType.contains(where: { $0 == tobaccoType }) {
                        self.selectedFilters.tobaccoType.removeAll(where: { $0 == tobaccoType })
                    } else {
                        self.selectedFilters.tobaccoType.append(tobaccoType)
                    }
                    self.reloadFilters()
                    self.initializeTimer()
                }
            let row = TableRow<MultiSegmentedTobaccoTableViewCell>(item: item)
            rows.append(row)
        }

        // tasteType
        if !filters.tasteType.isEmpty {
            let selectedIds = Set(selectedFilters.tasteType.map { $0.uid })
            let items = filters.tasteType.map {
                FilterTobaccoCollectionViewCellItem(label: $0.name, isSelect: selectedIds.contains($0.uid))
            }
            let item = CategoriesTobaccoFiltersViewCellTableViewCellItem(
                title: "Типы вкусов",
                items: items,
                didSelect: { [weak self] index in
                    guard let self else { return }
                    let tasteType = self.filters.tasteType[index]
                    if let index = self.selectedFilters.tasteType.firstIndex(where: { $0.id == tasteType.id }) {
                        self.selectedFilters.tasteType.remove(at: index)
                    } else {
                        self.selectedFilters.tasteType.append(tasteType)
                    }
                    self.reloadFilters()
                    self.initializeTimer()
                },
                clearAction: { [weak self] in
                    guard let self else { return }
                    self.selectedFilters.tasteType = []
                    self.updateFilter()
                })
            let row = TableRow<CategoriesTobaccoFiltersViewCellTableViewCell>(item: item)
            rows.append(row)
        }

        // tastes
        if !filters.tastes.isEmpty {
            let selectedIds = Set(selectedFilters.tastes.map { $0.id })
            let items = filters.tastes.map {
                FilterTobaccoCollectionViewCellItem(label: $0.taste, isSelect: selectedIds.contains($0.id))
            }
            let item = CategoriesTobaccoFiltersViewCellTableViewCellItem(
                title: "Вкусы",
                items: items,
                didSelect: { [weak self] index in
                    guard let self else { return }
                    let taste = self.filters.tastes[index]
                    if let index = self.selectedFilters.tastes.firstIndex(where: { $0.id == taste.id }) {
                        self.selectedFilters.tastes.remove(at: index)
                    } else {
                        self.selectedFilters.tastes.append(taste)
                    }
                    self.reloadFilters()
                    self.initializeTimer()
                },
                clearAction: { [weak self] in
                    guard let self else { return }
                    self.selectedFilters.tastes = []
                    self.updateFilter()
                })
            let row = TableRow<CategoriesTobaccoFiltersViewCellTableViewCell>(item: item)
            rows.append(row)
        }

        let section = TableSection(rows: rows)
        section.headerHeight = 0.0
        section.footerHeight = 0.0

        tableDirector += section
        reloadData()
    }

    private func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableDirector?.reload()
        }
    }

    private func initializeTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: Constant.timerLimit,
                                     repeats: false, block: { [weak self] _ in
            guard let self else { return }
            self.timer?.invalidate()
            self.timer = nil
            self.view.showBlockLoading()
            self.updateFilter()
        })
    }

    private func updateFilter() {
        view.showBlockLoading()
        interactor.updateFilters(selectedFilters)
    }

    private func reloadFilters() {
        if filters.isEmpty {
            let action = ActionWithTitle(
                title: R.string.localizable.tobaccoFilterEmptyButtonTitle(),
                action: { [weak self] in
                    self?.touchAllClearButton()
                    self?.view.hideInfoView()
                })
            var viewModel = InfoViewModel(image: R.image.notFound(),
                                          title: R.string.localizable.tobaccoFilterEmptyTitle(),
                                          subtitle: R.string.localizable.tobaccoFilterEmptyMessage(),
                                          primaryAction: action)
            viewModel.topView = view.getCloseButton()
            view.showInfoView(viewModel: viewModel)
        } else {
            setupContent(filters)
        }
    }
}

// MARK: - InteractorOutputProtocol implementation
extension TobaccoFiltersPresenter: TobaccoFiltersInteractorOutputProtocol {
    func receivedFilters(_ filters: TobaccoFilters) {
        isDownloadData = true
        self.filters = filters
        reloadFilters()
        // TODO: - добавить множественное число
        view.updateCounter(filters.count == 0 ? nil : "Найдено \(filters.count) табаков")
        view.hideLoading()
    }

    func receivedError(_ error: HTError) {
        view.hideLoading()
        if isDownloadData {
            router.showError(with: error.message)
        } else {
            view.showErrorView(isUnexpectedError: error != .noInternetConnection) { [weak self] in
                self?.view.hideErrorView()
                self?.interactor.receiveStartingData()
            }
        }
    }

    func selectedFilters(_ selectedFilters: TobaccoFilters) {
        self.selectedFilters = selectedFilters
    }
}

// MARK: - ViewOutputProtocol implementation
extension TobaccoFiltersPresenter: TobaccoFiltersViewOutputProtocol {
    func viewDidLoad() {
        let tableView = view.getTableView()
        tableDirector = TableDirector(tableView: tableView)
        interactor.receiveStartingData()
        view.showBlockLoading()
    }

    func touchAllClearButton() {
        selectedFilters = TobaccoFilters()
        view.showBlockLoading()
        interactor.receiveBaseFilters()
    }

    func touchApplyButton() {
        router.applyFiltersView(selectedFilters)
    }

    func touchCloseButton() {
        router.dismissView()
    }
}

private extension TobaccoFilters {
    init() {
        manufacturer = []
        tastes = []
        tasteType = []
        tobaccoType = []
        count = 0
    }
}

private struct Constant {
    static let timerLimit = 1.0
}

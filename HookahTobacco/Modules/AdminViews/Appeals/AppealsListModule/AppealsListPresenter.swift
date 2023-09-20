//
//
//  AppealsListPresenter.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 19.09.2023.
//
//

import Foundation
import TableKit
import UIKit
import IVCollectionKit

class AppealsListPresenter: NSObject {
    // MARK: - Public properties
    weak var view: AppealsListViewInputProtocol!
    var interactor: AppealsListInteractorInputProtocol!
    var router: AppealsListRouterProtocol!

    // MARK: - Private properties
    private var allThemes: [ThemeAppeal] = []
    private var selectedThemes: [ThemeAppeal] = []
    private var selectedStatus: AppealStatus?
    private var themesDirector: CustomCollectionDirector?
    private var tableDirector: TableDirector?
    private var isLoadingData: Bool = false
    private var isError: Bool = false
    private var oldContentHeight: CGFloat = 0.0

    // MARK: - Private methods
    private func setupAppealsContent(_ appeals: [AppealResponse]) {
        guard let tableDirector else { return }
        tableDirector.clear()

        var rows: [Row] = []

        let dateFormatter = DateFormatter(format: "dd.MM.YY HH:mm")
        for appeal in appeals {
            var info: [DescriptionStackViewItem] = []
            info.append(DescriptionStackViewItem(name: R.string.localizable.appealsListInfoIdTitle(),
                                                 description: "\(appeal.id)"))
            info.append(DescriptionStackViewItem(name: R.string.localizable.appealsListInfoNameTitle(),
                                                 description: appeal.name))
            info.append(DescriptionStackViewItem(name: R.string.localizable.appealsListInfoEmailTitle(),
                                                 description: appeal.email))
            info.append(DescriptionStackViewItem(name: R.string.localizable.appealsListInfoThemeTitle(),
                                                 description: appeal.theme.name))
            info.append(DescriptionStackViewItem(name: R.string.localizable.appealsListInfoCreatedDateTitle(),
                                                 description: dateFormatter.string(from: appeal.createdDate)))
            info.append(DescriptionStackViewItem(name: R.string.localizable.appealsListInfoStatusTitle(),
                                                 description: appeal.status.title))
            if let handledDate = appeal.handledDate {
                info.append(DescriptionStackViewItem(name: R.string.localizable.appealsListInfoHandledDateTitle(),
                                                     description: dateFormatter.string(from: handledDate)))
            }
            let item = AppealTableViewCellItem(info: info)
            let row = TableRow<AppealTableViewCell>(item: item).on(.click) { [weak self] options in
                self?.interactor.receiveAppealForEdit(by: options.indexPath.row)
            }
            rows.append(row)
        }

        let section = TableSection(rows: rows)
        section.headerHeight = 0.0
        section.footerHeight = 0.0
        tableDirector += section
        reload()
    }

    private func reload() {
        DispatchQueue.main.async { [weak self] in
            self?.tableDirector?.reload()
        }
    }

    private func setupThemesFilterContent() {
        guard let themesDirector else { return }
        themesDirector.removeAll()

        var rows: [AbstractCollectionItem] = []

        let setIds = Set(selectedThemes.map { $0.id })
        for theme in allThemes {
            let item = FilterTobaccoCollectionViewCellItem(label: theme.name, isSelect: setIds.contains(theme.id))
            let row = CollectionItem<FilterTobaccoCollectionViewCell>(item: item)
            rows.append(row)
        }

        let section = CollectionSection(items: rows)

        themesDirector += section
        themesDirector.reload()
    }
}

// MARK: - InteractorOutputProtocol implementation
extension AppealsListPresenter: AppealsListInteractorOutputProtocol {
    func receivedAppeals(_ appeals: [AppealResponse]) {
        isLoadingData = false
        isError = false
        setupAppealsContent(appeals)
        view.hideLoading()
    }

    func receivedThemes(_ themes: [ThemeAppeal]) {
        allThemes = themes
        setupThemesFilterContent()
    }

    func receivedAppeal(_ appeal: AppealResponse) {
        router.showDetailAppeal(appeal)
    }

    func receivedError(_ error: HTError) {
        view.hideLoading()
        isError = true
        isLoadingData = false
    }
}

// MARK: - ViewOutputProtocol implementation
extension AppealsListPresenter: AppealsListViewOutputProtocol {
    func viewDidLoad() {
        let tableView = view.getTableView()
        tableDirector = TableDirector(tableView: tableView, scrollDelegate: self)
        let themesCollView = view.getThemesCollectionView()
        themesCollView.didSelect = { [weak self] indexPath in
            guard let self else { return }
            let touchTheme = self.allThemes[indexPath.row]
            if let index = self.selectedThemes.firstIndex(where: { $0.id == touchTheme.id }) {
                self.selectedThemes.remove(at: index)
            } else {
                self.selectedThemes.append(touchTheme)
            }
            self.setupThemesFilterContent()
        }
        themesDirector = CustomCollectionDirector(collectionView: themesCollView)
        view.showLoading()
        interactor.startingLoadingData()
        interactor.receiveThemes()
    }

    func didSelectStatus(by index: Int) {
        selectedStatus = AppealStatus(rawValue: index)
    }

    func pressedApplyButton() {
        interactor.receiveAppeal(with: selectedThemes, status: selectedStatus)
    }

    func pressedClearButton() {
        selectedThemes = []
        selectedStatus = nil
        view.clearStatus()
        setupThemesFilterContent()
        interactor.receiveAppeal(with: selectedThemes, status: selectedStatus)
    }
}

// MARK: - UIScrollViewDelegate implementation
extension AppealsListPresenter: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + scrollView.frame.height >
            (scrollView.contentSize.height + oldContentHeight) / 2),
            !isLoadingData,
            !isError {
            interactor.receiveNextPage()
            isLoadingData = true
            oldContentHeight = scrollView.contentSize.height
        }
    }
}

extension AppealStatus {
    var title: String {
        switch self {
        case .notViewed:
            return R.string.localizable.appealsListStatucNotViewed()
        case .processing:
            return R.string.localizable.appealsListStatucProcessing()
        case .handled:
            return R.string.localizable.appealsListStatucHandled()
        }
    }
}

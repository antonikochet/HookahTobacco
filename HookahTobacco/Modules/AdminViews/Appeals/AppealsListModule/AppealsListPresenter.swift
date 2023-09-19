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

class AppealsListPresenter {
    // MARK: - Public properties
    weak var view: AppealsListViewInputProtocol!
    var interactor: AppealsListInteractorInputProtocol!
    var router: AppealsListRouterProtocol!

    // MARK: - Private properties
    private var tableDirector: TableDirector?

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
}

// MARK: - InteractorOutputProtocol implementation
extension AppealsListPresenter: AppealsListInteractorOutputProtocol {
    func receivedAppeals(_ appeals: [AppealResponse]) {
        view.hideLoading()
        setupAppealsContent(appeals)
    }

    func receivedAppeal(_ appeal: AppealResponse) {
        router.showDetailAppeal(appeal)
    }

    func receivedError(_ error: HTError) {
        view.hideLoading()
    }
}

// MARK: - ViewOutputProtocol implementation
extension AppealsListPresenter: AppealsListViewOutputProtocol {
    func viewDidLoad() {
        let tableView = view.getTableView()
        tableDirector = TableDirector(tableView: tableView)
        view.showLoading()
        interactor.startingLoadingData()
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

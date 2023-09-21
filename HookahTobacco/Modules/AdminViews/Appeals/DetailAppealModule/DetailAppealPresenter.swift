//
//
//  DetailAppealPresenter.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 20.09.2023.
//
//

import Foundation
import TableKit

class DetailAppealPresenter {
    // MARK: - Public properties
    weak var view: DetailAppealViewInputProtocol!
    var interactor: DetailAppealInteractorInputProtocol!
    var router: DetailAppealRouterProtocol!

    // MARK: - Private properties
    private var tableDirector: TableDirector?

    // MARK: - Private methods
    private func setupTableContent(_ appeal: AppealResponse, _ contents: [DetailAppealContent]) {
        guard let tableDirector else { return }
        tableDirector.clear()

        var rows: [Row] = []

        // appeal info
        let infoRow = setupInfoCell(appeal)
        rows.append(infoRow)

        // message
        let messageItem = AppealMessageTableViewCellItem(title: "Обращение", message: appeal.message)
        let messageRow = TableRow<AppealMessageTableViewCell>(item: messageItem)
        rows.append(messageRow)

        // contents
        if !contents.isEmpty {
            let item = DetailAppealContentTableViewCellItem(
                title: R.string.localizable.detailAppealContentsTitle(),
                contents: contents
            ) { [weak self] index in
                self?.interactor.receiveURLContent(at: index)
            }
            let row = TableRow<DetailAppealContentTableViewCell>(item: item)
            rows.append(row)
        }

        // answer
        let answerItem = AppealAnswerTableViewCellItem(anwser: appeal.replyMessage,
                                                       isEnableSaveButton: appeal.status != .handled
        ) { [weak self] newAnswer in
            self?.view.showBlockLoading()
            self?.interactor.saveNewAnswer(newAnswer)
        }
        let answerRow = TableRow<AppealAnswerTableViewCell>(item: answerItem)
        rows.append(answerRow)

        // handled button
        if appeal.status == .processing {
            let handledItem = ButtonProfileTableViewCellItem(
                text: R.string.localizable.detailAppealHandledButtonTitle()
            ) { [weak self] in
                self?.view.showBlockLoading()
                self?.interactor.handledAppeal()
            }
            let handledRow = TableRow<ButtonProfileTableViewCell>(item: handledItem)
            rows.append(handledRow)
        }

        let section = TableSection(rows: rows)
        section.headerHeight = 0.0
        section.footerHeight = 0.0
        tableDirector += section
        reload()
    }
    private func setupInfoCell(_ appeal: AppealResponse) -> Row {
        let dateFormatter = DateFormatter(format: "dd.MM.YY HH:mm")
        var info: [DescriptionStackViewItem] = []
        info.append(DescriptionStackViewItem(name: R.string.localizable.detailAppealInfoIdTitle(),
                                             description: "\(appeal.id)"))
        info.append(DescriptionStackViewItem(name: R.string.localizable.detailAppealInfoNameTitle(),
                                             description: appeal.name))
        info.append(DescriptionStackViewItem(name: R.string.localizable.detailAppealInfoEmailTitle(),
                                             description: appeal.email))
        info.append(DescriptionStackViewItem(name: R.string.localizable.detailAppealInfoThemeTitle(),
                                             description: appeal.theme.name))
        info.append(DescriptionStackViewItem(name: R.string.localizable.detailAppealInfoCreatedDateTitle(),
                                             description: dateFormatter.string(from: appeal.createdDate)))
        info.append(DescriptionStackViewItem(name: R.string.localizable.detailAppealInfoStatusTitle(),
                                             description: appeal.status.title))
        if let handledDate = appeal.handledDate {
            info.append(DescriptionStackViewItem(name: R.string.localizable.detailAppealInfoHandledDateTitle(),
                                                 description: dateFormatter.string(from: handledDate)))
        }
        let infoItem = AppealTableViewCellItem(info: info)
        return TableRow<AppealTableViewCell>(item: infoItem)
    }

    private func reload() {
        DispatchQueue.main.async { [weak self] in
            self?.tableDirector?.reload()
        }
    }
}

// MARK: - InteractorOutputProtocol implementation
extension DetailAppealPresenter: DetailAppealInteractorOutputProtocol {
    func showData(appeal: AppealResponse, contents: [DetailAppealContent]) {
        view.hideLoading()
        setupTableContent(appeal, contents)
    }

    func receivedSuccessHandled() {
        view.hideLoading()
        router.showSuccess(delay: 2.0) { [weak self] in
            self?.router.popView()
        }
    }

    func receivedError(_ error: HTError) {
        view.hideLoading()
        router.showError(with: error.message)
    }

    func receivedURLContent(_ url: URL) {
        router.showDetailContent(url)
    }
}

// MARK: - ViewOutputProtocol implementation
extension DetailAppealPresenter: DetailAppealViewOutputProtocol {
    func viewDidLoad() {
        let tableView = view.getTableView()
        tableDirector = TableDirector(tableView: tableView)
        view.showBlockLoading()
        interactor.startingShowData()
    }
}

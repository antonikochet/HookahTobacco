//
//
//  TobaccoListPresenter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 26.10.2022.
//
//

import Foundation
import TableKit
import UIKit

class TobaccoListPresenter: NSObject {
    // MARK: - Public properties
    weak var view: TobaccoListViewInputProtocol!
    var interactor: TobaccoListInteractorInputProtocol!
    var router: TobaccoListRouterProtocol!

    // MARK: - Private properties
    private var tobaccoItems: [TobaccoListTableCellItem] = []
    private var tableDirector: TableDirector?
    private var isDownloadData: Bool = false
    private var isLoadingData: Bool = false
    private var isError: Bool = false
    private var oldContentHeight: CGFloat = 0.0

    // MARK: - Private methods
    private func createItem(for tobacco: Tobacco) -> TobaccoListTableCellItem {
        let taste = tobacco.tastes
            .map { $0.taste }
            .joined(separator: ", ")
        let item = TobaccoListTableCellItem(
            name: tobacco.name,
            tasty: taste,
            manufacturerName: tobacco.nameManufacturer,
            isFavorite: tobacco.isFavorite,
            isWantBuy: tobacco.isWantBuy,
            isShowWantBuyButton: true,
            image: tobacco.image
        )
        item.favoriteAction = { [weak self] item in
            guard let index = self?.tobaccoItems.firstIndex(where: { $0 === item }) else { return }
            self?.interactor.updateFavorite(by: index)
        }
        item.wantBuyAction = { [weak self] item in
            guard let index = self?.tobaccoItems.firstIndex(where: { $0 === item }) else { return }
            self?.interactor.updateWantBuy(by: index)
        }
        return item
    }
    private func createRow(at item: TobaccoListTableCellItem) -> Row {
        TableRow<TobaccoListCell>(item: item).on(.click) { [weak self] options in
            self?.interactor.receiveDataForShowDetail(by: options.indexPath.row)
        }
    }

    private func setupContentView(_ tobaccos: [Tobacco]) {
        guard let tableDirector else { return }
        tableDirector.clear()
        tobaccoItems.removeAll()
        var rows: [Row] = []

        for tobacco in tobaccos {
            let item = createItem(for: tobacco)
            tobaccoItems.append(item)
            let row = createRow(at: item)
            rows.append(row)
        }

        let section = TableSection(rows: rows)
        section.headerHeight = 0.0
        section.footerHeight = 0.0
        tableDirector += section
        reloadData()
    }

    private func updateContentView(_ tobacco: Tobacco, at index: Int) {
        guard tobaccoItems.count > index else { return }
        let item = createItem(for: tobacco)
        let indexPath = IndexPath(row: index, section: 0)
        tobaccoItems[index] = item
        let row = createRow(at: item)
        DispatchQueue.main.async { [weak self] in
            self?.tableDirector?.reloadRow(at: indexPath, with: row)
        }
    }

    private func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableDirector?.reload()
        }
    }
}

// MARK: - InteractorOutputProtocol implementation
extension TobaccoListPresenter: TobaccoListInteractorOutputProtocol {
    func receivedSuccess(_ data: [Tobacco]) {
        isDownloadData = true
        isLoadingData = false
        isError = false
        if data.isEmpty {
            let title: String
            var message: String = ""
            switch interactor.receiveTobaccoListInput() {
            case .none:
                title = "Список табаков пуст"
            case .favorite:
                title = "Любимых табаков нет"
                message = "Пройдитесь по списку табаков и добавьте в список любимых"
            case .wantBuy:
                title = "Список покупок табаков пуст"
                message = "Пройдитесь по списку табаков и добавьте в список покупок табаки"
            }
            view.showErrorView(title: title,
                               message: message,
                               image: UIImage(named: "notFound"),
                               buttonAction: nil)
        } else {
            setupContentView(data)
        }
        setupContentView(data)
        view.hideLoading()
        view.endRefreshing()
    }

    func receivedError(_ error: HTError) {
        view.endRefreshing()
        view.hideLoading()
        isError = true
        isLoadingData = false
        switch error {
        case .noInternetConnection, .unexpectedError, .unknownError, .serverNotAvailable:
            if isDownloadData {
                router.showError(with: error.message)
            } else {
                view.showErrorView(isUnexpectedError: error != .noInternetConnection) { [weak self] in
                    self?.view.hideErrorView()
                    self?.interactor.startReceiveData()
                }
            }
        default:
            router.showError(with: error.message)
        }
    }

    func receivedUpdate(for data: Tobacco, at index: Int) {
        updateContentView(data, at: index)
    }

    func receivedDataForShowDetail(_ tobacco: Tobacco) {
        router.showDetail(for: tobacco)
    }

    func receivedDataForEditing(_ tobacco: Tobacco) {
        router.showAddTobacco(tobacco, delegate: self)
    }

    func showMessageUser(_ message: String) {
        DispatchQueue.main.async {
            self.router.showMessage(with: message)
        }
    }

    func removeTobacco(at index: Int) {
        guard let tableDirector,
              let firstSection = tableDirector.sections.first else { return }
        firstSection.delete(rowAt: index)
        tobaccoItems.remove(at: index)
        reloadData()
    }
}

// MARK: - ViewOutputProtocol implementation
extension TobaccoListPresenter: TobaccoListViewOutputProtocol {
    func viewDidLoad() {
        let tableView = view.getTableView()
        tableDirector = TableDirector(tableView: tableView, scrollDelegate: self)
        let title: String
        switch interactor.receiveTobaccoListInput() {
        case .none:
            title = "Табаки"
        case .favorite:
            title = "Любимые табаки"
        case .wantBuy:
            title = "Список для покупки"
        }
        view.setupView(title: title)
        view.showLoading()
        interactor.startReceiveData()
    }

    func didStartingRefreshView() {
        oldContentHeight = 0.0
        isError = false
        interactor.updateData()
    }
}

// MARK: - OutputModule implementation
extension TobaccoListPresenter: AddTobaccoOutputModule {
    func sendChangedTobacco(_ tobacco: Tobacco) {
        interactor.receivedDataFromOutside(tobacco)
    }
}

// MARK: - OutputModule implementation
extension TobaccoListPresenter: UIScrollViewDelegate {
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

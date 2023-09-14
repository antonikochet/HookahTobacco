//
//
//  SelectListBottomSheetPresenter.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 14.09.2023.
//
//

import Foundation
import TableKit

class SelectListBottomSheetPresenter {
    // MARK: - Public properties
    weak var view: SelectListBottomSheetViewInputProtocol!
    var interactor: SelectListBottomSheetInteractorInputProtocol!
    var router: SelectListBottomSheetRouterProtocol!

    // MARK: - Private properties
    private var tableDirector: TableDirector?
    private var items: [String] = []
    private var selectedIndex: Int?

    // MARK: - Private methods
    private func setupTableContent(_ items: [String], selectedIndex: Int?) {
        guard let tableDirector else { return }

        tableDirector.clear()

        var rows: [Row] = []

        for (index, item) in items.enumerated() {
            let itm = SelectListBottomSheetTableViewCellItem(title: item, isSelect: index == selectedIndex)
            let row = TableRow<SelectListBottomSheetTableViewCell>(item: itm).on(.click) { [weak self] options in
                guard let self else { return }
                let title = options.item.title
                if let index = self.items.firstIndex(of: title) {
                    self.selectedIndex = index
                }
                self.setupTableContent(self.items, selectedIndex: self.selectedIndex)
            }
            rows.append(row)
        }

        let section = TableSection(rows: rows)
        section.headerHeight = 0.0
        section.footerHeight = 0.0
        tableDirector += section
        let height: CGFloat = 44.0 * CGFloat(items.count)
        view.setHeightTableView(height)
        reloadTableView()
    }

    private func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableDirector?.reload()
        }
    }
}

// MARK: - InteractorOutputProtocol implementation
extension SelectListBottomSheetPresenter: SelectListBottomSheetInteractorOutputProtocol {
    func receivedStartingData(title: String?, items: [String], selectedIndex: Int?) {
        if let title {
            view.setupView(title: title)
        }
        self.items = items
        self.selectedIndex = selectedIndex
        setupTableContent(items, selectedIndex: selectedIndex)
    }
}

// MARK: - ViewOutputProtocol implementation
extension SelectListBottomSheetPresenter: SelectListBottomSheetViewOutputProtocol {
    func viewDidLoad() {
        let tableView = view.getTableView()
        tableDirector = TableDirector(tableView: tableView)
    }

    func viewDidAppear() {
        interactor.receiveStartingData()
    }

    func pressedDoneButton() {
        router.dismissView(selectedIndex)
    }
}

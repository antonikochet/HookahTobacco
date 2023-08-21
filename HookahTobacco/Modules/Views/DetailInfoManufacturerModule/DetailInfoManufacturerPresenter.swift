//
//
//  DetailInfoManufacturerPresenter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 31.10.2022.
//
//

import Foundation
import TableKit

class DetailInfoManufacturerPresenter {
    // MARK: - Public properties
    weak var view: DetailInfoManufacturerViewInputProtocol!
    var interactor: DetailInfoManufacturerInteractorInputProtocol!
    var router: DetailInfoManufacturerRouterProtocol!

    // MARK: - Private properties
    private var linkToManufacturer: String?
    private var detailInfoManufacturerItem: DetailInfoManufacturerTableCellItem?
    private var tableDirector: TableDirector!
    private var lineTobaccos: [String: [Tobacco]] = [:]
    private var linesSection: [TobaccoLine] = []
    private var tobaccos: [Tobacco] = []
    private var hidesSectionTobacco: [String: Bool] = [:]

    // MARK: - Private methods
    private func createDetailInfoManufacturerItem(
        for manufacturer: Manufacturer
    ) -> DetailInfoManufacturerTableCellItem {

        DetailInfoManufacturerTableCellItem(
            country: "Страна производителя: \(manufacturer.country)",
            description: manufacturer.description.isEmpty ? "" : "Описание: \n\(manufacturer.description)",
            iconImage: manufacturer.image
        )
    }
    private func createTobaccoItem(for tobacco: Tobacco) -> TobaccoListTableCellItem {
        let item = TobaccoListTableCellItem(
            name: tobacco.name,
            tasty: tobacco.tastes
                .map { $0.taste }
                .joined(separator: ", "),
            manufacturerName: "",
            isFavorite: tobacco.isFavorite,
            isWantBuy: tobacco.isWantBuy,
            isShowWantBuyButton: false,
            image: tobacco.image
        )
        item.favoriteAction = { [weak self] item in
            guard let index = self?.tobaccos.firstIndex(where: { $0.name == item.name }) else { return }
            self?.interactor.updateFavorite(by: index)
        }
        return item
    }
    private func createTobaccoRow(at item: TobaccoListTableCellItem) -> Row {
        TableRow<TobaccoListCell>(item: item)
    }

    private func setupContentView(_ manufacturer: Manufacturer?, _ tobaccos: [String: [Tobacco]]?) {
        tableDirector.clear()

        setupDetailInfoManufacturerCell(manufacturer)
        let lastSection: TableSection
        if let tobaccos, !tobaccos.isEmpty {
            lastSection = setupTobaccoSection(tobaccos)
        } else {
            lastSection = setupEmptyTableCell()
        }

        if let linkToManufacturer {
            lastSection.footerTitle = linkToManufacturer
            lastSection.footerHeight = 30.0
        }

        DispatchQueue.main.async { [weak self] in
            self?.tableDirector.reload()
        }
    }
    private func setupDetailInfoManufacturerCell(_ manufacturer: Manufacturer?) {
        var rows: [Row] = []
        if let manufacturer {
            detailInfoManufacturerItem = createDetailInfoManufacturerItem(for: manufacturer)
        }
        if let detailInfoManufacturerItem {
            let row = TableRow<DetailInfoManufacturerTableCell>(item: detailInfoManufacturerItem)
            rows.append(row)
        }
        let firstSection = TableSection(rows: rows)
        firstSection.headerHeight = 0.0
        firstSection.footerHeight = 0.0
        tableDirector += firstSection
    }
    private func setupEmptyTableCell() -> TableSection {
        let item = EmptyTableCellItem(title: .emptyTitle,
                                      description: .emptyDescription)
        let row = TableRow<EmptyTableCell>(item: item)
        let section = TableSection(rows: [row])
        section.headerHeight = 0.0
        tableDirector += section

        return section
    }
    private func setupTobaccoSection(_ tobaccos: [String: [Tobacco]]) -> TableSection {
        var sections: [TableSection] = []
        linesSection.removeAll()
        for (_, tbcs) in tobaccos {
            let line = tbcs.first!.line
            linesSection.append(line)
            guard let isHideRows = hidesSectionTobacco[line.name] else { continue }
            var rows: [Row] = []
            if !isHideRows {
                rows = tbcs.map { createTobaccoRow(at: createTobaccoItem(for: $0)) }
            }
            let section = TableSection(rows: rows)
            DispatchQueue.main.async {
                let header = DetailManufacturerLineHeaderView()
                let viewModel = DetailManufacturerLineHeaderViewModel(
                    name: tobaccos.count > 1 ? line.name : .baseLineName,
                    description: line.description,
                    isHideTobacco: isHideRows) { [weak self] nameLine in
                        guard let self = self else { return }
                        self.hidesSectionTobacco[self.lineTobaccos.count > 1 ? nameLine : .base]?.toggle()
                        self.setupContentView(nil, self.lineTobaccos)
                    }
                header.configure(with: viewModel)
                section.headerView = header
                section.headerHeight = DetailManufacturerLineHeaderCalculator.calculateHeightView(
                    width: self.tableDirector.tableView!.frame.width,
                    with: viewModel
                )
            }
            sections.append(section)
        }
        tableDirector += sections

        return sections.last!
    }

    private func updateTobaccoContentView(for tobacco: Tobacco) {
        if let index = tobaccos.firstIndex(where: { $0.id == tobacco.id }) {
            tobaccos[index] = tobacco
        }
        let line = tobacco.line.name
        guard let index = lineTobaccos[line]?.firstIndex(where: { $0.id == tobacco.id }),
              let section = linesSection.firstIndex(where: { $0.name == line }) else { return }
        lineTobaccos[line]?[index] = tobacco
        let item = createTobaccoItem(for: tobacco)

        let indexPath = IndexPath(row: index, section: section + 1)
        let row = createTobaccoRow(at: item)
        DispatchQueue.main.async { [weak self] in
            self?.tableDirector.reloadRow(at: indexPath, with: row)
        }
    }
}

// MARK: - InteractorOutputProtocol implementation
extension DetailInfoManufacturerPresenter: DetailInfoManufacturerInteractorOutputProtocol {
    func initialDataForPresentation(_ manufacturer: Manufacturer) {
        view.setupNameManufacturer(manufacturer.name)
        if let link = manufacturer.link, !link.isEmpty {
            linkToManufacturer = .linkManufacturer + link
        }
        setupContentView(manufacturer, nil)
    }

    func receivedTobacco(with tobaccos: [Tobacco]) {
        self.tobaccos = tobaccos
        let tobaccoDict = Dictionary(grouping: tobaccos) { tobacco in
            tobacco.line.name
        }
        lineTobaccos = tobaccoDict
        hidesSectionTobacco = Dictionary(uniqueKeysWithValues: tobaccoDict.keys.map({ ($0, false) }))
        setupContentView(nil, tobaccoDict)
    }

    func receivedError(_ error: HTError) {
        router.showError(with: error.message)
    }

    func receivedUpdate(for tobacco: Tobacco, at index: Int) {
        updateTobaccoContentView(for: tobacco)
    }
}

// MARK: - ViewOutputProtocol implementation
extension DetailInfoManufacturerPresenter: DetailInfoManufacturerViewOutputProtocol {
    func viewDidLoad() {
        let tableView = view.getTableView()
        tableDirector = TableDirector(tableView: tableView)
        interactor.receiveStartingDataView()
    }
}

private extension String {
    static let emptyTitle = "Упс... Список табаков пуст"
    static let emptyDescription = "В базу данных еще не внесли табаки производителя..."
    static let linkManufacturer = "Сайт производителя: "
    static let baseLineName = "Табаки производителя"
    static let base = "Base"
}

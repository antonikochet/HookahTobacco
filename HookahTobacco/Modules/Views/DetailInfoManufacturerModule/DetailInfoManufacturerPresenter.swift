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
        TobaccoListTableCellItem(
            name: tobacco.name,
            tasty: tobacco.tastes
                .map { $0.taste }
                .joined(separator: ", "),
            manufacturerName: "",
            image: tobacco.image
        )
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
        for (line, tbcs) in tobaccos {
            linesSection.append(tbcs.first!.line)
            var rows: [Row] = []
            for tobacco in tbcs {
                let item = createTobaccoItem(for: tobacco)
                let row = createTobaccoRow(at: item)
                rows.append(row)
            }
            let section = TableSection(rows: rows)
            DispatchQueue.main.async {
                let header = DetailInfoManufacturerTobaccoLineTableViewHeaderView(frame: .zero)
                header.text = tobaccos.count > 1 ? line : .baseLineName
                section.headerView = header
                section.headerHeight = 40.0
            }
            sections.append(section)
        }
        tableDirector += sections

        return sections.last!
    }

    private func updateTobaccoContentView(for tobacco: Tobacco) {
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
        let tobaccoDict = Dictionary(grouping: tobaccos) { tobacco in
            tobacco.line.name
        }
        lineTobaccos = tobaccoDict
        setupContentView(nil, tobaccoDict)
    }

    func receivedError(with message: String) {
        router.showError(with: message)
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
}

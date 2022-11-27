//
//
//  DetailInfoManufacturerViewController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 31.10.2022.
//
//

import UIKit
import SnapKit

protocol DetailInfoManufacturerViewInputProtocol: AnyObject {
    func showData()
    func updateRow(at index: Int)
}

protocol DetailInfoManufacturerViewOutputProtocol: AnyObject {
    var nameManufacturer: String? { get }
    var tobaccoNumberOfRows: Int { get }
    var detailViewModelCell: DetailInfoManufacturerCellViewModelProtocol? { get }
    var linkToManufacturerWebside: String? { get }
    func tobaccoViewModelCell(at row: Int) -> TobaccoListCellViewModel
    var isTobaccosEmpty: Bool { get }
    func viewDidLoad()
}

class DetailInfoManufacturerViewController: UIViewController {
    // MARK: - Public properties
    var presenter: DetailInfoManufacturerViewOutputProtocol!

    // MARK: - Private properties
    private var detailCellHeight: CGFloat = 0

    // MARK: - Private UI
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.register(DetailInfoManufacturerTableCell.self,
                           forCellReuseIdentifier: DetailInfoManufacturerTableCell.identifier)
        tableView.register(TobaccoListCell.self,
                           forCellReuseIdentifier: TobaccoListCell.identifier)
        tableView.register(EmptyCell.self,
                           forCellReuseIdentifier: EmptyCell.identifier)
        return tableView
    }()

    // MARK: - Life Cycle ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        presenter.viewDidLoad()
    }

    // MARK: - Setups
    private func setupSubviews() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    // MARK: - Private methods

    // MARK: - Selectors

}

// MARK: - ViewInputProtocol implementation
extension DetailInfoManufacturerViewController: DetailInfoManufacturerViewInputProtocol {
    func showData() {
        navigationItem.title = presenter.nameManufacturer
        tableView.reloadData()
    }

    func updateRow(at index: Int) {
        let indexPath = IndexPath(row: index, section: 1)
        if tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

// MARK: - UITableViewDataSource implementation
extension DetailInfoManufacturerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return presenter.isTobaccosEmpty ? 1 : presenter.tobaccoNumberOfRows
        default: return 0
        }
    }

    // swiftlint: disable force_cast
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailInfoManufacturerTableCell.identifier,
                                                     for: indexPath) as! DetailInfoManufacturerTableCell
            cell.viewModel = presenter.detailViewModelCell
            return cell
        case 1:
            if !presenter.isTobaccosEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: TobaccoListCell.identifier,
                                                         for: indexPath) as! TobaccoListCell
                cell.viewModel = presenter.tobaccoViewModelCell(at: indexPath.row)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyCell.identifier,
                                                         for: indexPath) as! EmptyCell
                cell.title = "Упс... Список табаков пуст"
                cell.descriptionText = "В базу данных еще не внесли табаки производителя..."
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    // swiftlint: enable force_cast

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: return presenter.isTobaccosEmpty ? nil : "Табаки производителя"
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 1: return presenter.linkToManufacturerWebside
        default: return nil
        }
    }
}

// MARK: - UITableViewDelegate implementation
extension DetailInfoManufacturerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if detailCellHeight == 0,
               let cell = tableView.cellForRow(at: indexPath) as? DetailInfoManufacturerTableCell {
                detailCellHeight = cell.heightCell
            }
            if detailCellHeight == 0 { return tableView.frame.height * 0.5 }
            return detailCellHeight
        case 1:
            return presenter.isTobaccosEmpty ? EmptyCell.heightCell : tableView.frame.height / 6
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 1,
           let header = view as? UITableViewHeaderFooterView {
            header.textLabel!.font = UIFont.systemFont(ofSize: 24.0, weight: .medium)
            header.textLabel!.numberOfLines = 1
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
}

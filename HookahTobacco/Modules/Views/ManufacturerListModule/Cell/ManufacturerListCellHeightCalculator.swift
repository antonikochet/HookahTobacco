//
//  ManufacturerListCellHeightCalculator.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.01.2023.
//

import UIKit
import TableKit

final class ManufacturerListCellHeightCalculator: RowHeightCalculator {
    private(set) weak var tableView: UITableView?
    private var cachedHeights = [Int: CGFloat]()
    private var countCellInView: Int

    init(tableView: UITableView?, countCellInView: Int) {
        self.tableView = tableView
        self.countCellInView = countCellInView
    }

    func height(forRow row: Row, at indexPath: IndexPath) -> CGFloat {
        guard let tableView = tableView else { return 0 }
        let hash = row.hashValue ^ Int(tableView.bounds.size.width).hashValue

        if let height = cachedHeights[hash] {
            return height
        }

        let height = tableView.bounds.height / CGFloat(countCellInView)
        cachedHeights[hash] = height

        return height
    }

    func estimatedHeight(forRow row: Row, at indexPath: IndexPath) -> CGFloat {
        guard let tableView = tableView else { return 0 }
        let hash = row.hashValue ^ Int(tableView.bounds.size.width).hashValue

        if let height = cachedHeights[hash] {
            return height
        }

        if let estimatedHeight = row.estimatedHeight, estimatedHeight > 0 {
            return estimatedHeight
        }

        return UITableView.automaticDimension
    }

    func invalidate() {
        cachedHeights.removeAll()
    }
}

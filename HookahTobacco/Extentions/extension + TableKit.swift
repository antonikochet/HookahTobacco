//
//  extension + TableKit.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.01.2023.
//

import Foundation
import TableKit

extension TableDirector {
    func reloadRow(at indexPath: IndexPath, with row: Row) {
        guard sections.count > indexPath.section else { return }
        let section = sections[indexPath.section]
        guard section.rows.count > indexPath.row else { return }
        section.replace(rowAt: indexPath.row, with: row)

        tableView?.reloadData()
    }
}

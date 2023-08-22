//
//  CustomTableDirector.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 22.08.2023.
//

import UIKit
import TableKit

enum CustomTableDirectorActionsType {
    case edit
    case delete
}

class CustomTableDirector: TableDirector {

    var customAction: ((_ row: Row, _ action: CustomTableDirectorActionsType) -> Void)?

    func row(at indexPath: IndexPath) -> Row? {
        if indexPath.section < sections.count && indexPath.row < sections[indexPath.section].rows.count {
            return sections[indexPath.section].rows[indexPath.row]
        }
        return nil
    }

    func hasAction(_ action: TableRowActionType, atIndexPath indexPath: IndexPath) -> Bool {
        guard let row = row(at: indexPath) else { return false }
        return row.has(action: action)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard let row = row(at: indexPath) else { return nil }
        var actions: [UIContextualAction] = []

        if hasAction(.canEdit, atIndexPath: indexPath) {
            let editAction = UIContextualAction(
                style: .normal,
                title: nil
            ) { [weak self] (_, _, completionHandler) in
                self?.customAction?(row, .edit)
                completionHandler(true)
            }
            editAction.title = "Изменить"
            editAction.backgroundColor = .orange
            actions.append(editAction)
        }

        if hasAction(.canDelete, atIndexPath: indexPath) {
            let deleteAction = UIContextualAction(
                style: .destructive,
                title: nil
            ) { [weak self] (_, _, completionHandler) in
                self?.customAction?(row, .delete)
                completionHandler(true)
            }
            deleteAction.title = "Удалить"
            deleteAction.backgroundColor = .red
            actions.append(deleteAction)
        }

        return UISwipeActionsConfiguration(actions: actions)
    }
}

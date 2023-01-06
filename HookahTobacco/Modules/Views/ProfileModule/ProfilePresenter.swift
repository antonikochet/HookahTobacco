//
//
//  ProfilePresenter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 04.01.2023.
//
//

import Foundation
import TableKit

final class ProfilePresenter {
    // MARK: - Public properties
    weak var view: ProfileViewInputProtocol!
    var interactor: ProfileInteractorInputProtocol!
    var router: ProfileRouterProtocol!

    // MARK: - Private properties
    private var tableDirector: TableDirector!

    // MARK: - Private methods
    private func setupContentView(_ user: UserProtocol) {
        tableDirector.clear()
        var rows: [Row] = []

        // profile cell
        var name = ""
        if let firstName = user.firstName,
           let lastName = user.lastName {
            name = "\(firstName) \(lastName)"
        } else if user.isAnonymous {
            name = "Anonymous-\(user.uid.prefix(6))"
        }
        let profileItem = ProfileTableViewCellItem(photo: nil, name: name)
        let profileCell = TableRow<ProfileTableViewCell>(item: profileItem)
        rows.append(profileCell)

        // registration button if user is anonymous
        if user.isAnonymous {
            let anonymousInfoItem = AnonymousInfoTableViewCellItem(text: .anonymousInfoText)
            let anonymousInfoCell = TableRow<AnonymousInfoTableViewCell>(item: anonymousInfoItem)
            rows.append(anonymousInfoCell)
            let registrationAnonymousItem = ButtonProfileTableViewCellItem(
                text: "Зарегистрировать аккаунт"
            ) { [weak self] in
                self?.router.showRegistrationView()
            }
            let registrationAnonymousCell = TableRow<ButtonProfileTableViewCell>(item: registrationAnonymousItem)
            rows.append(registrationAnonymousCell)
        }

        // admin button if user is admin
        if user.isAdmin {
            let adminButtonItem = ButtonProfileTableViewCellItem(text: "Меню админа") { [weak self] in
                self?.router.showAdminMenu()
            }
            let adminButtonCell = TableRow<ButtonProfileTableViewCell>(item: adminButtonItem)
            rows.append(adminButtonCell)
        }

        let section = TableSection(rows: rows)
        section.headerHeight = 0.0
        section.footerHeight = 0.0
        tableDirector += section
        reloadData()
    }

    private func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableDirector.reload()
        }
    }
}

// MARK: - InteractorOutputProtocol implementation
extension ProfilePresenter: ProfileInteractorOutputProtocol {
    func receivedProfileInfoSuccess(_ user: UserProtocol) {
        view.hideSpinner()
        setupContentView(user)
    }

    func receivedProfileInfoError(_ message: String) {
        view.hideSpinner()
        router.showError(with: message)
    }

    func receivedLogoutSuccess() {
        router.showLoginView()
    }

    func receivedLogoutError(_ message: String) {
        router.showError(with: message)
    }
}

// MARK: - ViewOutputProtocol implementation
extension ProfilePresenter: ProfileViewOutputProtocol {
    func viewDidLoad() {
        let tableView = view.getTableView()
        tableDirector = TableDirector(tableView: tableView, cellHeightCalculator: nil)
    }

    func viewWillAppear() {
        view.showSpinner()
        interactor.receiveProfileInfo()
    }

    func pressedLogoutButton() {
        interactor.logout()
    }
}

private extension String {
    static let anonymousInfoText = """
    Ваш аккаунт является анонимным, для сохранения удаленно любимых табаков необходимо зарегистрироваться!
    """
}

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
        }
        let profileItem = ProfileTableViewCellItem(photo: nil, name: name)
        let profileCell = TableRow<ProfileTableViewCell>(item: profileItem)
        rows.append(profileCell)

        // admin button if user is admin
        if user.isAdmin {
            let adminButtonItem = ButtonProfileTableViewCellItem(
                text: R.string.localizable.profileAdminButtonTitle()
            ) { [weak self] in
                self?.router.showAdminMenu()
            }
            let adminButtonCell = TableRow<ButtonProfileTableViewCell>(item: adminButtonItem)
            rows.append(adminButtonCell)
        }

        let editProfileItem = ButtonProfileTableViewCellItem(text: "Изменить данные") { [weak self] in
            guard let self else { return }
            let data = ProfileEditDataModule(isRegistration: false, user: RegistrationUser(user), output: self)
            self.router.appRouter.presentViewModally(module: ProfileEditModule.self, moduleData: data)
        }
        let editProfileRow = TableRow<ButtonProfileTableViewCell>(item: editProfileItem)
        rows.append(editProfileRow)

        // button for show tobacco list with filter: favorite
        let favoriteItem = ButtonProfileTableViewCellItem(
            text: R.string.localizable.profileFavoriteButtonTitle()
        ) { [weak self] in
            self?.router.showFavoriteList()
        }
        let favoriteRow = TableRow<ButtonProfileTableViewCell>(item: favoriteItem)
        rows.append(favoriteRow)

        // button for show tobacco list with filter: wantToBuy
        let wantToBuyItem = ButtonProfileTableViewCellItem(
            text: R.string.localizable.profileWantToBuyButtonTitle()
        ) { [weak self] in
            self?.router.showWantToBuyList()
        }
        let wantToBuyRow = TableRow<ButtonProfileTableViewCell>(item: wantToBuyItem)
        rows.append(wantToBuyRow)

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
    func receivedError(_ error: HTError) {
        view.hideLoading()
        router.showError(with: error.message)
    }

    func receivedProfileInfoSuccess(_ user: UserProtocol) {
        view.hideLoading()
        setupContentView(user)
    }

    func receivedLogoutSuccess() {
        router.showLoginView()
    }
}

// MARK: - ViewOutputProtocol implementation
extension ProfilePresenter: ProfileViewOutputProtocol {
    func viewDidLoad() {
        let tableView = view.getTableView()
        tableDirector = TableDirector(tableView: tableView, cellHeightCalculator: nil)
    }

    func viewWillAppear() {
        view.showLoading()
        interactor.receiveProfileInfo()
    }

    func pressedLogoutButton() {
        interactor.logout()
    }
}

extension ProfilePresenter: ProfileEditOutputModule {
    func receivedUpdateUser(_ user: UserProtocol) {
        setupContentView(user)
    }
}

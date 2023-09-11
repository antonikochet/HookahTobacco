//
//
//  AdminMenuViewController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 08.10.2022.
//
//

import UIKit
import SnapKit

protocol AdminMenuViewInputProtocol: AnyObject {
}

protocol AdminMenuViewOutputProtocol: AnyObject {
    func pressedAddManufacturerButton()
    func pressedAddTobaccoButton()
    func pressedEditManufacturers()
    func pressedEditTobacco()
    func pressedUpgradeBDVersion()
    func pressedLogoutButton()
}

class AdminMenuViewController: UIViewController {
    // MARK: - Public properties
    var presenter: AdminMenuViewOutputProtocol!

    // MARK: - UI properties
    private let addManufacturer = ApplyButton(style: .primary)
    private let addTobacco = ApplyButton(style: .primary)
    private let editManufacturer = ApplyButton(style: .primary)
    private let editTobacco = ApplyButton(style: .primary)
    private let upgradeDBVersion = ApplyButton(style: .primary)

    // MARK: - Lifecycle ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = R.string.localizable.adminMenuTitle()
        view.backgroundColor = R.color.primaryBackground()

        setupSubviews()
        setupRightButtonNavigationBar()
    }

    // MARK: - Setups
    private func setupSubviews() {
        addManufacturer.setTitle(R.string.localizable.adminMenuAddManufacturerTitle(), for: .normal)
        addManufacturer.action = { [weak self] in
            self?.presenter.pressedAddManufacturerButton()
        }
        addManufacturer.setupButton(superView: view, topViewConstraint: view.safeAreaLayoutGuide.snp.top)

        addTobacco.setTitle(R.string.localizable.adminMenuAddTobaccoTitle(), for: .normal)
        addTobacco.action = { [weak self] in
            self?.presenter.pressedAddTobaccoButton()
        }
        addTobacco.setupButton(superView: view, topViewConstraint: addManufacturer.snp.bottom)

        editManufacturer.setTitle(R.string.localizable.adminMenuEditManufacturerTitle(), for: .normal)
        editManufacturer.action = { [weak self] in
            self?.presenter.pressedEditManufacturers()
        }
        editManufacturer.setupButton(superView: view, topViewConstraint: addTobacco.snp.bottom)

        editTobacco.setTitle(R.string.localizable.adminMenuEditTobaccoTitle(), for: .normal)
        editTobacco.action = { [weak self] in
            self?.presenter.pressedEditTobacco()
        }
        editTobacco.setupButton(superView: view, topViewConstraint: editManufacturer.snp.bottom)

        upgradeDBVersion.setTitle(R.string.localizable.adminMenuUpgradeVersionTitle(), for: .normal)
        upgradeDBVersion.action = { [weak self] in
            self?.presenter.pressedUpgradeBDVersion()
        }
        upgradeDBVersion.setupButton(superView: view, topViewConstraint: editTobacco.snp.bottom)
    }

    private func setupRightButtonNavigationBar() {
        let button = Button(style: .third)
        button.setTitle(R.string.localizable.adminMenuLogoutTitle())
        button.action = { [weak self] in
            self?.presenter.pressedLogoutButton()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
}

// MARK: - AdminMenuViewInputProtocol implementation
extension AdminMenuViewController: AdminMenuViewInputProtocol {

}

// MARK: - extension UIButton
fileprivate extension UIButton {
    func setupButton(superView: UIView, topViewConstraint: ConstraintItem) {
        superView.addSubview(self)
        self.snp.makeConstraints { make in
            make.top.equalTo(topViewConstraint).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
}

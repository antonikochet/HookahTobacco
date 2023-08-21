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
    private let addManufacturer = ApplyButton()
    private let addTobacco = ApplyButton()
    private let editManufacturer = ApplyButton()
    private let editTobacco = ApplyButton()
    private let upgradeDBVersion = ApplyButton()

    // MARK: - Lifecycle ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Меню"
        view.backgroundColor = .systemBackground

        setupSubviews()
        setupRightButtonNavigationBar()
    }

    // MARK: - Setups
    private func setupSubviews() {
        addManufacturer.setTitle("Добавить производителя", for: .normal)
        addManufacturer.action = { [weak self] in
            self?.presenter.pressedAddManufacturerButton()
        }
        addManufacturer.setupButton(superView: view, topViewConstraint: view.safeAreaLayoutGuide.snp.top)

        addTobacco.setTitle("Добавить табак", for: .normal)
        addTobacco.action = { [weak self] in
            self?.presenter.pressedAddTobaccoButton()
        }
        addTobacco.setupButton(superView: view, topViewConstraint: addManufacturer.snp.bottom)

        editManufacturer.setTitle("Изменить производителей", for: .normal)
        editManufacturer.action = { [weak self] in
            self?.presenter.pressedEditManufacturers()
        }
        editManufacturer.setupButton(superView: view, topViewConstraint: addTobacco.snp.bottom)

        editTobacco.setTitle("Изменить табаки", for: .normal)
        editTobacco.action = { [weak self] in
            self?.presenter.pressedEditTobacco()
        }
        editTobacco.setupButton(superView: view, topViewConstraint: editManufacturer.snp.bottom)

        upgradeDBVersion.setTitle("Повысить версию базы данных", for: .normal)
        upgradeDBVersion.action = { [weak self] in
            self?.presenter.pressedUpgradeBDVersion()
        }
        upgradeDBVersion.setupButton(superView: view, topViewConstraint: editTobacco.snp.bottom)
    }

    private func setupRightButtonNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "log out",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(touchRightButtonNavBar))
    }

    @objc
    private func touchRightButtonNavBar() {
        presenter.pressedLogoutButton()
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

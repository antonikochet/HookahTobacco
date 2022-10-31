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
    func showError(with title: String, and message: String)
}

protocol AdminMenuViewOutputProtocol: AnyObject {
    func pressedAddManufacturerButton()
    func pressedAddTobaccoButton()
    func pressedEditManufacturers()
    func pressedEditTobacco()
    func pressedLogoutButton()
}

class AdminMenuViewController: UIViewController {
    var presenter: AdminMenuViewOutputProtocol!
    
    //MARK: UI properties
    private let addManufacturer = UIButton.createAppBigButton("Добавить производителя")
    private let addTobacco = UIButton.createAppBigButton("Добавить табак")
    private let editManufacturer = UIButton.createAppBigButton("Изменить производителей")
    private let editTobacco = UIButton.createAppBigButton("Изменить табаки")
    
    //MARK: override ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Меню"
        view.backgroundColor = .white
        
        setupSubviews()
        setupRightButtonNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        addManufacturer.createCornerRadius()
        addTobacco.createCornerRadius()
        editManufacturer.createCornerRadius()
        editTobacco.createCornerRadius()
    }
    
    //MARK: setup subviews
    private func setupSubviews() {
        addManufacturer.setupButton(superView: view, topViewConstraint: view.safeAreaLayoutGuide.snp.top)
        addManufacturer.addTarget(self, action: #selector(touchButton(_:)), for: .touchUpInside)
        
        addTobacco.setupButton(superView: view, topViewConstraint: addManufacturer.snp.bottom)
        addTobacco.addTarget(self, action: #selector(touchButton(_:)), for: .touchUpInside)
        
        editManufacturer.setupButton(superView: view, topViewConstraint: addTobacco.snp.bottom)
        editManufacturer.addTarget(self, action: #selector(touchButton(_:)), for: .touchUpInside)
        
        editTobacco.setupButton(superView: view, topViewConstraint: editManufacturer.snp.bottom)
        editTobacco.addTarget(self, action: #selector(touchButton(_:)), for: .touchUpInside)
    }
    
    private func setupRightButtonNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "log out", style: .done, target: self, action: #selector(touchRightButtonNavBar))
    }
    
    @objc
    private func touchButton(_ button: UIButton) {
        if addManufacturer == button {
            presenter.pressedAddManufacturerButton()
        } else if addTobacco == button {
            presenter.pressedAddTobaccoButton()
        } else if editManufacturer == button {
            presenter.pressedEditManufacturers()
        } else if editTobacco == button {
            presenter.pressedEditTobacco()
        }
    }
    
    @objc
    private func touchRightButtonNavBar() {
        presenter.pressedLogoutButton()
    }
}

extension AdminMenuViewController: AdminMenuViewInputProtocol {
    func showError(with title: String, and message: String) {
        showAlertError(title: title, message: message)
    }
}

fileprivate extension UIButton {
    func setupButton(superView: UIView, topViewConstraint: ConstraintItem) {
        superView.addSubview(self)
        self.snp.makeConstraints { make in
            make.top.equalTo(topViewConstraint).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(50)
        }
    }
}

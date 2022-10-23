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
    func pressedLogoutButton()
}

class AdminMenuViewController: UIViewController {
    var presenter: AdminMenuViewOutputProtocol!
    
    //MARK: UI properties
    private let addManufacturer = UIButton.createButton(text: "Добавить производителя")
    private let addTobacco = UIButton.createButton(text: "Добавить табак")
    private let editManufacturer = UIButton.createButton(text: "Изменить производителей")
    
    //MARK: override ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Меню"
        view.backgroundColor = .white
        
        setupSubviews()
        setupRightButtonNavigationBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        addManufacturer.createCornerRadius()
        addTobacco.createCornerRadius()
        editManufacturer.createCornerRadius()
    }
    
    //MARK: setup subviews
    private func setupSubviews() {
        addManufacturer.setupButton(superView: view, topViewConstraint: view.safeAreaLayoutGuide.snp.top)
        addManufacturer.addTarget(self, action: #selector(touchButton(_:)), for: .touchUpInside)
        
        addTobacco.setupButton(superView: view, topViewConstraint: addManufacturer.snp.bottom)
        addTobacco.addTarget(self, action: #selector(touchButton(_:)), for: .touchUpInside)
        
        editManufacturer.setupButton(superView: view, topViewConstraint: addTobacco.snp.bottom)
        editManufacturer.addTarget(self, action: #selector(touchButton(_:)), for: .touchUpInside)
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
    static func createButton(text: String) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.8
        button.titleLabel?.font = UIFont.appFont(size: 20, weight: .bold)
        return button
    }
    
    func createCornerRadius() {
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
    }
    
    func setupButton(superView: UIView, topViewConstraint: ConstraintItem) {
        superView.addSubview(self)
        self.snp.makeConstraints { make in
            make.top.equalTo(topViewConstraint).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(50)
        }
    }
}

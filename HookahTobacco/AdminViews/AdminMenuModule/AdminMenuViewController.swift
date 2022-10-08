//
//
//  AdminMenuViewController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 08.10.2022.
//
//

import UIKit

protocol AdminMenuViewInputProtocol: AnyObject {
    func showError(with title: String, and message: String)
}

protocol AdminMenuViewOutputProtocol: AnyObject {
    func pressedAddManufacturerButton()
    func pressedAddTobaccoButton()
    func pressedLogoutButton()
}

class AdminMenuViewController: UIViewController {
    var presenter: AdminMenuViewOutputProtocol!
    
    //MARK: UI properties
    private let addManufacturer: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить производителя", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.8
        button.titleLabel?.font = UIFont.appFont(size: 20, weight: .bold)
        return button
    }()
    
    private let addTobacco: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить табак", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.8
        button.titleLabel?.font = UIFont.appFont(size: 20, weight: .bold)
        return button
    }()
    
    //MARK: override ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Меню"
        view.backgroundColor = .white
        
        setupSubviews()
        setupRightButtonNavigationBar()
    }
    
    //MARK: setup subviews
    private func setupSubviews() {
        view.addSubview(addManufacturer)
        addManufacturer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(32)
            make.leading.trailing.equalTo(view).inset(24)
            make.height.equalTo(50)
        }
        addManufacturer.addTarget(self, action: #selector(touchButton(_:)), for: .touchUpInside)
        
        view.addSubview(addTobacco)
        addTobacco.snp.makeConstraints { make in
            make.top.equalTo(addManufacturer.snp.bottom).offset(24)
            make.leading.trailing.equalTo(view).inset(24)
            make.height.equalTo(50)
        }
        addTobacco.addTarget(self, action: #selector(touchButton(_:)), for: .touchUpInside)
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

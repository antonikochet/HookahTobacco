//
//  AddedMenuViewController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 28.09.2022.
//

import UIKit
import SnapKit

class AddedMenuViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Меню"
        view.backgroundColor = .white
        
        setupSubviews()
        setupRightButtonNavigationBar()
    }
    
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
            let addManufacturerVC = AddManufacturerViewController()
            navigationController?.pushViewController(addManufacturerVC, animated: true)
        } else if addTobacco == button {
            let addTobaccoVC = AddTobaccoViewController()
            navigationController?.pushViewController(addTobaccoVC, animated: true)
        }
    }
    
    @objc
    private func touchRightButtonNavBar() {
        FireBaseAuthService.shared.logout { [weak self] error in
            if let error = error {
                let nserror = error as NSError
                self?.showAlertError(title: "Ошибка", message: "Выйти из пользователя не вышло, причина: \(nserror.userInfo)")
            } else {
                self?.navigationController?.setViewControllers([LoginViewController()], animated: true)
            }
        }
    }
}

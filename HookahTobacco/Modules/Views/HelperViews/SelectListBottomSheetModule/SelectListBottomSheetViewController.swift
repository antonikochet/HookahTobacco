//
//
//  SelectListBottomSheetViewController.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 14.09.2023.
//
//

import UIKit
import SnapKit

protocol SelectListBottomSheetViewInputProtocol: AnyObject {
    func getTableView() -> UITableView
    func setupView(title: String)
    func setHeightTableView(_ height: CGFloat)
}

protocol SelectListBottomSheetViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func viewDidAppear()
    func pressedDoneButton()
}

class SelectListBottomSheetViewController: UIViewController, BottomSheetPresenter {
    // MARK: - BottomSheetPresenter
    var isShowGrip: Bool = false
    var dismissOnPull: Bool = false

    // MARK: - Public properties
    var presenter: SelectListBottomSheetViewOutputProtocol!

    // MARK: - UI properties
    private let titleLabel = UILabel()
    private let doneButton = Button(style: .third)
    private let tableView = UITableView()

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.presenter.viewDidAppear()
        }
    }

    // MARK: - Setups
    private func setupUI() {
        setupView()
        setupDoneButton()
        setupTitleLabel()
        setupTableView()
    }
    private func setupView() {
        view.backgroundColor = R.color.primaryBackground()
    }
    private func setupDoneButton() {
        doneButton.setTitle("Готово")
        doneButton.action = { [weak self] in
            self?.presenter.pressedDoneButton()
        }
        view.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16.0)
            make.top.equalToSuperview().offset(22.0).priority(999)
        }
    }
    private func setupTitleLabel() {
        titleLabel.font = UIFont.appFont(size: 20.0, weight: .semibold)
        titleLabel.textColor = R.color.primaryTitle()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left

        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16.0)
            make.top.equalToSuperview().offset(22.0).priority(999)
            make.trailing.equalTo(doneButton.snp.leading).inset(-8.0)
        }
    }
    private func setupTableView() {
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        tableView.isScrollEnabled = false
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(0).priority(999)
        }
    }
    // MARK: - Private methods

    // MARK: - Selectors

}

// MARK: - ViewInputProtocol implementation
extension SelectListBottomSheetViewController: SelectListBottomSheetViewInputProtocol {
    func getTableView() -> UITableView {
        tableView
    }

    func setupView(title: String) {
        titleLabel.text = title
    }

    func setHeightTableView(_ height: CGFloat) {
        tableView.snp.updateConstraints { make in
            make.height.equalTo(height).priority(999)
        }
        sheetViewController?.updateIntrinsicHeight()
    }
}

//
//
//  SuccessBottomSheetViewController.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 19.09.2023.
//
//

import UIKit
import FittedSheets

struct SuccessBottomSheetViewItem {
    let title: String
    let message: String?
    let image: UIImage?
    let primaryAction: ActionWithTitle?
    let secondaryAction: ActionWithTitle?
}

class SuccessBottomSheetViewController: UIViewController, BottomSheetPresenter {
    // MARK: - BottomSheetPresenter
    var sizes: [SheetSize] = [.marginFromTop(100.0)]
    var dismissOnPull: Bool = false
    var dismissOnOverlayTap: Bool = false

    // MARK: - Public properties
    var item: SuccessBottomSheetViewItem?

    // MARK: - UI properties
    private let infoView = InfoView()

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureInfoView()
    }

    // MARK: - Setups
    private func setupUI() {
        setupScreen()
        setupInfoView()
    }
    private func setupScreen() {
        view.backgroundColor = R.color.primaryBackground()
    }
    private func setupInfoView() {
        view.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    // MARK: - Private methods
    private func configureInfoView() {
        guard let item else { return }
        let viewModel = InfoViewModel(image: item.image,
                                      title: item.title,
                                      subtitle: item.message,
                                      primaryAction: item.primaryAction,
                                      secondaryAction: item.secondaryAction)
        infoView.configure(viewModel: viewModel)
    }

    // MARK: - Selectors

}

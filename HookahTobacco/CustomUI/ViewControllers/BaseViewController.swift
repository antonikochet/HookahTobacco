//
//  BaseViewController.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 07.08.2023.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {

    // MARK: - Public properties
    var parentForProgressView: UIView {
        view
    }

    // MARK: - Private UI
    private var blockView: UIView?
    private var loadingView: LoadingView?

    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
    }

    // MARK: - Setups
    private func setupAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }
    private func setupBlockView() -> UIView {
        let blockView = UIView()
        blockView.backgroundColor = .systemGray6.withAlphaComponent(0.1)
        parentForProgressView.addSubview(blockView)
        blockView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.blockView?.removeFromSuperview()
        self.blockView = blockView
        return blockView
    }

    private func setupLoadingView(blockView: UIView?) {
        let loadingView = LoadingView(isBlur: true)
        if let blockView {
            blockView.addSubview(loadingView)
        } else {
            parentForProgressView.addSubview(loadingView)
        }
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        self.loadingView?.removeFromSuperview()
        self.loadingView = loadingView
    }

    private func setupErrorView(_ viewModel: InfoViewModel) {
        let infoView = InfoView()
        view.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            if let topView = viewModel.topView {
                make.top.equalTo(topView.snp.bottom)
            } else {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            }
            if let bottomView = viewModel.bottomView {
                make.bottom.equalTo(bottomView.snp.top)
            } else {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
        }
        infoView.configure(viewModel: viewModel)
    }

    // MARK: - Public methods
    func hideViewTapped() {
        view.endEditing(true)
    }

    // MARK: - Selectors
    @objc private func viewTapped() {
        hideViewTapped()
    }
}

// MARK: - ViewProtocol implementation
extension BaseViewController: ViewProtocol {
    func showLoading() {
        setupLoadingView(blockView: nil)
        loadingView?.startLoading()
    }

    func showBlockLoading() {
        let blockView = setupBlockView()
        setupLoadingView(blockView: blockView)
        loadingView?.startLoading()
    }

    func hideLoading() {
        loadingView?.stopLoading()
        loadingView?.removeFromSuperview()
        loadingView = nil
        blockView?.removeFromSuperview()
        blockView = nil
    }

    func showErrorView(title: String, message: String, image: UIImage?,
                       refreshButtonTitle: String, buttonAction: CompletionBlock?) {
        var primaryAction: ActionWithTitle?
        if buttonAction != nil {
            primaryAction = ActionWithTitle(title: refreshButtonTitle,
                                            action: {
                                                buttonAction?()
                                            })
        }
        let viewModel = InfoViewModel(
            image: image,
            title: title,
            subtitle: message,
            primaryAction: primaryAction)
        setupErrorView(viewModel)
    }

    func hideErrorView() {
        view.subviews.filter({ $0 is InfoView }).forEach { $0.removeFromSuperview() }
    }

    func showInfoView(viewModel: InfoViewModel) {
        setupErrorView(viewModel)
    }

    func hideInfoView() {
        hideErrorView()
    }
}

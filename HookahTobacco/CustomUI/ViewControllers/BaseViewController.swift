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

    // MARK: - Setups
    private func setupBlockView() -> UIView {
        let blockView = UIView()
        blockView.backgroundColor = .systemGray6.withAlphaComponent(0.1)
        parentForProgressView.addSubview(blockView)
        blockView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
        self.loadingView = loadingView
    }

    private func setupErrorView(_ viewModel: InfoViewModel) {
        let infoView = InfoView()
        view.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        infoView.configure(viewModel: viewModel)
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

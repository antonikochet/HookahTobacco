//
//  HTScrollContentViewController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 10.11.2022.
//

import UIKit
import SnapKit

class HTScrollContentViewController: BaseViewController {
    // MARK: - Public UI
    let stackView = UIStackView()

    var stackViewInset: UIEdgeInsets {
        UIEdgeInsets()
    }

    // MARK: - Private UI
    let contentScrollView = UIView()
    private let scrollView = UIScrollView()

    // MARK: - Setups
    func setupSubviews() {
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delaysContentTouches = false
        view.addSubview(scrollView)

        scrollView.addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 16.0
        contentScrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(stackViewInset)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideViewTapped))
        view.addGestureRecognizer(tapGesture)
    }

    func setupConstrainsScrollView(
        top: ConstraintRelatableTarget? = nil, topConstant: CGFloat = 0,
        leading: ConstraintRelatableTarget? = nil, leadingConstant: CGFloat = 0,
        trailing: ConstraintRelatableTarget? = nil, trailingConstant: CGFloat = 0,
        bottom: ConstraintRelatableTarget? = nil, bottomConstant: CGFloat = 0
    ) {
        scrollView.snp.makeConstraints({ make in
            if let top = top {
                make.top.equalTo(top).offset(topConstant)
            } else {
                make.top.equalToSuperview().offset(topConstant)
            }
            if let leading = leading {
                make.leading.equalTo(leading).offset(leadingConstant)
            } else {
                make.leading.equalToSuperview().offset(leadingConstant)
            }
            if let trailing = trailing {
                make.trailing.equalTo(trailing).inset(trailingConstant)
            } else {
                make.trailing.equalToSuperview().inset(trailingConstant)
            }
            if let bottom = bottom {
                make.bottom.equalTo(bottom).inset(bottomConstant)
            } else {
                make.bottom.equalToSuperview().inset(bottomConstant) }
        })
    }

    // MARK: - Public methods
    public func setOffset(_ contentOffset: CGPoint) {
        scrollView.setContentOffset(contentOffset, animated: true)
    }

    // MARK: - Selectors
    @objc func hideViewTapped() {
        view.endEditing(true)
    }
}

//
//  HTScrollContentViewController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 10.11.2022.
//

import UIKit
import SnapKit

class HTScrollContentViewController: UIViewController {
    // MARK: - Public UI
    let scrollView = UIScrollView()
    let contentScrollView = UIView()
    
    // MARK: - Setups
    func setupSubviews() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentScrollView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideViewTapped))
        view.addGestureRecognizer(tapGesture)
    }

    // MARK: - Selectors
    @objc private func hideViewTapped() {
        view.endEditing(true)
    }
}

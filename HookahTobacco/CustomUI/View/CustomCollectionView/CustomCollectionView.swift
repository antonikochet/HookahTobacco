//
//  CustomCollectionView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 14.11.2022.
//

import UIKit
import SnapKit

final class CustomCollectionView: UICollectionView {
    // MARK: - Public properties
    var didSelect: ((IndexPath) -> Void)?

    // MARK: - Init
    init() {
        let layout = CustomCollectionViewLayout()
        layout.interItemSpacing = 8
        super.init(frame: .zero, collectionViewLayout: layout)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
        backgroundColor = .clear
        snp.makeConstraints { $0.height.equalTo(0) }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Super methods and properties
    override var contentSize: CGSize {
        didSet {
            snp.updateConstraints { $0.height.equalTo(contentSize.height) }
        }
    }

    func setLayoutDelegate(_ delegate: CustomCollectionViewLayoutDelegate) {
        (collectionViewLayout as? CustomCollectionViewLayout)?.delegate = delegate
    }

    // MARK: - Selectors
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        if let indexPath = indexPathForItem(at: sender.location(in: self)) {
            didSelect?(indexPath)
        }
    }
}

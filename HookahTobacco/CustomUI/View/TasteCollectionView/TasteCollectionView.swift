//
//  TasteCollectionView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 14.11.2022.
//

import UIKit
import SnapKit

class TasteCollectionView: UICollectionView {
    // MARK: - Public properties
    var getItem: ((Int) -> TasteCollectionCellViewModel?)?
    var didSelect: ((Int) -> Void)?
    // MARK: - Init
    init() {
        let layout = TasteCollectionViewLayout()
        layout.interItemSpacing = 8
        super.init(frame: .zero, collectionViewLayout: layout)
        layout.delegate = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
        register(TasteCollectionViewCell.self,
                 forCellWithReuseIdentifier: TasteCollectionViewCell.identifier)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
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

    // MARK: - Selectors
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        if let indexPath = indexPathForItem(at: sender.location(in: self)) {
            didSelect?(indexPath.row)
        }
    }
}

// MARK: - TasteCollectionViewLayoutDelegate implementation
extension TasteCollectionView: TasteCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeForTasteAtIndexPath indexPath: IndexPath) -> CGSize {
        guard let viewModel = getItem?(indexPath.row) else { return .zero }
        let size = viewModel.label.sizeOfString(usingFont: TasteCollectionViewCell.tasteFont)
        let paddings = TasteCollectionViewCell.paddingLabel
        return CGSize(width: paddings.left + size.width + paddings.right,
                      height: paddings.top + size.height + paddings.bottom)
    }
}

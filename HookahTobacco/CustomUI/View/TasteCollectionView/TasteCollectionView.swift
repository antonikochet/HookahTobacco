//
//  TasteCollectionView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 14.11.2022.
//

import UIKit
import SnapKit

protocol TasteCollectionViewDelegate: AnyObject {
    func getItem(at index: Int) -> TasteCollectionCellViewModel
    var numberOfRows: Int { get }
    func didSelectTaste(at index: Int)
}

class TasteCollectionView: UICollectionView {
    // MARK: - Public properties
    weak var tasteDelegate: TasteCollectionViewDelegate!
    
    // MARK: - Init
    init() {
        let layout = TasteCollectionViewLayout()
        layout.interItemSpacing = 8
        super.init(frame: .zero, collectionViewLayout: layout)
        layout.delegate = self
        delegate = self
        dataSource = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
        register(TasteCollectionViewCell.self,
                 forCellWithReuseIdentifier: TasteCollectionViewCell.identifier)
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
}

// MARK: - TasteCollectionViewLayoutDelegate implementation
extension TasteCollectionView: TasteCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeForTasteAtIndexPath indexPath: IndexPath) -> CGSize {
        let viewModel = tasteDelegate.getItem(at: indexPath.row)
        let size = viewModel.taste.sizeOfString(usingFont: TasteCollectionViewCell.tasteFont)
        let paddings = TasteCollectionViewCell.paddingLabel
        return CGSize(width: paddings.left + size.width + paddings.right,
                      height: paddings.top + size.height + paddings.bottom)
    }
}

// MARK: - UICollectionViewDataSource implementation
extension TasteCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tasteDelegate.numberOfRows
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TasteCollectionViewCell.identifier, for: indexPath) as! TasteCollectionViewCell
        cell.viewModel = tasteDelegate.getItem(at: indexPath.row)
        return cell
    }
}

// MARK: - UICollectionViewDelegate implementation
extension TasteCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tasteDelegate.didSelectTaste(at: indexPath.row)
    }
}

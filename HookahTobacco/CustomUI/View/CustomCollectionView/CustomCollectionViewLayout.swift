//
//  CustomCollectionViewLayout.swift
//  HookahTobacco
//
//  Created by антон кочетков on 14.11.2022.
//

import UIKit

protocol CustomCollectionViewLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, sizeForTasteAtIndexPath indexPath: IndexPath) -> CGSize
}

class CustomCollectionViewLayout: UICollectionViewLayout {
    // MARK: - Public properties
    var interItemSpacing: CGFloat = 0

    weak var delegate: CustomCollectionViewLayoutDelegate?

    // MARK: - Private properties
    private var itemCache: [UICollectionViewLayoutAttributes] = []
    private var layoutHeight: CGFloat = 0.0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    // MARK: - override Properties
    override var collectionViewContentSize: CGSize {
        CGSize(width: contentWidth, height: layoutHeight)
    }

    // MARK: - override Methods
    override func prepare() {
        super.prepare()

        layoutHeight = 0.0
        itemCache.removeAll()
        guard let collectionView = collectionView else { return }
        var layoutWidthIterator: CGFloat = 0.0
        var itemSize: CGSize = .zero
        guard collectionView.numberOfSections > 0 else { return }
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(row: item, section: 0)
            itemSize = delegate?.collectionView(
                collectionView,
                sizeForTasteAtIndexPath: indexPath
            ) ?? .zero
            let residualWidth = layoutWidthIterator + itemSize.width + interItemSpacing * 2
            if residualWidth > collectionView.frame.width {
                layoutWidthIterator = 0.0
                layoutHeight += itemSize.height + interItemSpacing
            }

            let frame = CGRect(x: layoutWidthIterator + interItemSpacing,
                               y: layoutHeight,
                               width: itemSize.width,
                               height: itemSize.height)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            itemCache.append(attributes)
            layoutWidthIterator += frame.width + interItemSpacing
        }
        layoutHeight += itemSize.height
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)

        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []

        for attributes in itemCache where attributes.frame.intersects(rect) {
            visibleLayoutAttributes.append(attributes)
        }

        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        super.layoutAttributesForItem(at: indexPath)
        return itemCache[indexPath.row]
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        layoutHeight = 0.0
        return true
    }
}

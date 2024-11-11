//
//  ChipsCollectionViewLayout.swift
//
//
//  Created by антон кочетков on 14.11.2022.
//

import UIKit

public class ChipsCollectionViewLayout: UICollectionViewFlowLayout {
    // MARK: - Public properties

    // MARK: - Private properties
    private var itemCache: [Int: [UICollectionViewLayoutAttributes]] = [:]
    private var layoutHeight: CGFloat = 0.0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    // MARK: - override Properties
    public override var collectionViewContentSize: CGSize {
        CGSize(width: contentWidth, height: layoutHeight)
    }

    // MARK: - override Methods
    public override func prepare() {
        super.prepare()

        layoutHeight = 0.0
        itemCache.removeAll()
        
        guard let collectionView = collectionView else { return }
        guard collectionView.numberOfSections > 0 else { return }
        
        let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout
        
        for section in 0..<collectionView.numberOfSections {
            
            itemCache[section] = []
            
            let insetSection = delegate?.collectionView?(collectionView, layout: self, insetForSectionAt: section) ?? sectionInset
            let itemSpacing = delegate?.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: section) ?? minimumInteritemSpacing
            let lineSpacing = delegate?.collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: section) ?? minimumLineSpacing
            
            let contentWidth = contentWidth
            
            layoutHeight += insetSection.top
            
            var lineHeight: CGFloat = 0
            var layoutWidthIterator: CGFloat = insetSection.left
            var itemSize: CGSize = .zero
            
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(row: item, section: section)
                
                itemSize = delegate?.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) ?? self.itemSize
                
                if itemSize.height > lineHeight {
                    lineHeight = itemSize.height
                }
                let residualWidth = layoutWidthIterator + itemSize.width + itemSpacing + insetSection.right
                if residualWidth > contentWidth {
                    layoutWidthIterator = insetSection.left
                    layoutHeight += lineHeight + lineSpacing
                }
                
                let frame = CGRect(x: layoutWidthIterator,
                                   y: layoutHeight,
                                   width: itemSize.width,
                                   height: itemSize.height)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                
                itemCache[section]?.append(attributes)
                layoutWidthIterator += frame.width + itemSpacing
            }
            layoutHeight += lineHeight + insetSection.bottom
        }
    }

   public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)

        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        let itemCache = itemCache.reduce(into: []) { partialResult, section in
            section.value.forEach { partialResult.append($0) }
        }
        for attributes in itemCache where attributes.frame.intersects(rect) {
            visibleLayoutAttributes.append(attributes)
        }

        return visibleLayoutAttributes
    }

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        super.layoutAttributesForItem(at: indexPath)
        return itemCache[indexPath.section]?[indexPath.row]
    }

    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        layoutHeight = 0.0
        return true
    }
}

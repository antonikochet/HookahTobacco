//
//  CustomCollectionDirector.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 31.08.2023.
//

import UIKit
import IVCollectionKit

final class CustomCollectionDirector: CollectionDirector {

    init(collectionView: CustomCollectionView) {
        super.init(collectionView: collectionView)
        collectionView.setLayoutDelegate(self)
    }
}

extension CustomCollectionDirector: CustomCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeForTasteAtIndexPath indexPath: IndexPath) -> CGSize {
        let insets = collectionView.contentInset
        let boundingWidth = collectionView.bounds.width - insets.left - insets.right
        let boundingHeight = collectionView.bounds.height - insets.top - insets.bottom
        let boundingSize = CGSize(width: boundingWidth, height: boundingHeight)
        let size = section(for: indexPath.section)
                        .sizeForItem(at: indexPath, boundingSize: boundingSize)
        return size
    }
}

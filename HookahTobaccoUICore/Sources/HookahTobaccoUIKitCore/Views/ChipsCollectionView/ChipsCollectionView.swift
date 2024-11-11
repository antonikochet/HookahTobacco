//
//  ChipsCollectionView.swift
//  
//
//  Created by антон кочетков on 14.11.2022.
//

import UIKit
import SnapKit

public final class ChipsCollectionView: UICollectionView {
    // MARK: - Init
    public init() {
        let collectionLayout = ChipsCollectionViewLayout()
        super.init(frame: .zero, collectionViewLayout: collectionLayout)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        let collectionLayout = ChipsCollectionViewLayout()
        collectionViewLayout = collectionLayout
        setup()
    }
    
    // MARK: - overrides
    public override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    // MARK: - Setup
    private func setup() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
        backgroundColor = .clear
    }
}

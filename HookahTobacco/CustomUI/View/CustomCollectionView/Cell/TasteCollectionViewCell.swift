//
//  TasteCollectionViewCell.swift
//  HookahTobacco
//
//  Created by антон кочетков on 13.11.2022.
//

import UIKit
import SnapKit
import IVCollectionKit

struct TasteCollectionCellViewModel {
    let label: String
}

class TasteCollectionViewCell: UICollectionViewCell, ConfigurableCollectionItem {

    // MARK: - Private UI
    private let tasteLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.tasteLabel
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        return label
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setups
    private func setup() {
        contentView.backgroundColor = .systemGreen
        contentView.addSubview(tasteLabel)
        tasteLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(LayoutValues.paddingLabel)
        }
        contentView.layer.cornerRadius = LayoutValues.cornerRadiusCell
    }

    func configure(item: TasteCollectionCellViewModel) {
        tasteLabel.text = item.label
    }

    static func estimatedSize(item: TasteCollectionCellViewModel,
                              boundingSize: CGSize,
                              in section: AbstractCollectionSection) -> CGSize {
        let size = item.label.sizeOfString(usingFont: Fonts.tasteLabel)
        let paddings = LayoutValues.paddingLabel
        return CGSize(width: paddings.left + size.width + paddings.right,
                      height: paddings.top + size.height + paddings.bottom)
    }
}

private struct LayoutValues {
    static let paddingLabel: UIEdgeInsets = UIEdgeInsets(horizontal: 8, vertical: 4)
    static let cornerRadiusCell: CGFloat = 12
}

private struct Fonts {
    static let tasteLabel = UIFont.appFont(size: 16, weight: .medium)
}

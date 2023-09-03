//
//  FilterTobaccoCollectionViewCell.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 31.08.2023.
//

import UIKit
import IVCollectionKit
import SnapKit

struct FilterTobaccoCollectionViewCellItem {
    let label: String
    let isSelect: Bool
}

final class FilterTobaccoCollectionViewCell: UICollectionViewCell, ConfigurableCollectionItem {

    // MARK: - Private UI
    private let label = UILabel()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        setupContentView()
        setupLabel()
    }
    private func setupContentView() {
        contentView.layer.cornerRadius = 4.0
        contentView.clipsToBounds = true
        contentView.backgroundColor = Colors.unselectedBackground
    }
    private func setupLabel() {
        label.textAlignment = .center
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        label.font = Fonts.label
        label.textColor = Colors.unselectedLabelText
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(LayoutValues.paddingLabel)
        }
    }

    // MARK: - ConfigurableCollectionItem
    func configure(item: FilterTobaccoCollectionViewCellItem) {
        label.text = item.label
        if item.isSelect {
            label.textColor = Colors.selectedLabelText
            contentView.backgroundColor = Colors.selectedBackground
        } else {
            label.textColor = Colors.unselectedLabelText
            contentView.backgroundColor = Colors.unselectedBackground
        }
    }

    static func estimatedSize(item: FilterTobaccoCollectionViewCellItem,
                              boundingSize: CGSize,
                              in section: AbstractCollectionSection) -> CGSize {
        let size = item.label.sizeOfString(usingFont: Fonts.label)
        let paddings = LayoutValues.paddingLabel
        return CGSize(width: paddings.left + size.width + paddings.right,
                      height: paddings.top + size.height + paddings.bottom)
    }
}

private struct LayoutValues {
    static let paddingLabel: UIEdgeInsets = UIEdgeInsets(horizontal: 8, vertical: 4)
}
private struct Colors {
    static let unselectedBackground = R.color.fourthBackground()
    static let selectedBackground = R.color.primaryPurple()
    static let unselectedLabelText = R.color.primaryTitle()
    static let selectedLabelText = R.color.primaryWhite()
}
private struct Fonts {
    static let label = UIFont.appFont(size: 16, weight: .medium)
}

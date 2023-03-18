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

class TasteCollectionViewCell: UICollectionViewCell {
    // MARK: - Static properties
    static let identifier = NSStringFromClass(TasteCollectionViewCell.self)

    // MARK: - Public properties
    var viewModel: TasteCollectionCellViewModel! {
        didSet {
            tasteLabel.text = viewModel.label
        }
    }

    // MARK: - Private UI
    private let tasteLabel = UILabel()

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
        setupCell()
        setupTasteLabel()
    }
    private func setupCell() {
        contentView.backgroundColor = Colors.Cell.background
        contentView.layer.cornerRadius = LayoutValues.Cell.cornerRadius
    }
    private func setupTasteLabel() {
        tasteLabel.font = Fonts.taste
        tasteLabel.lineBreakMode = .byWordWrapping
        tasteLabel.textColor = Colors.TasteLabel.text

        contentView.addSubview(tasteLabel)
        tasteLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(LayoutValues.TasteLabel.padding)
        }
    }
}

extension TasteCollectionViewCell: ConfigurableCollectionItem {
    func configure(item: TasteCollectionCellViewModel) {
        tasteLabel.text = item.label
    }

    static func estimatedSize(item: TasteCollectionCellViewModel,
                              boundingSize: CGSize,
                              in section: AbstractCollectionSection) -> CGSize {
        CGSize(width: 40,
               height: LayoutValues.TasteLabel.padding.top +
                       Fonts.taste.lineHeight +
                       LayoutValues.TasteLabel.padding.bottom)
    }
}

extension TasteCollectionViewCell {
    static let tasteFont = Fonts.taste
    static let paddingLabel = LayoutValues.TasteLabel.padding
}

private struct LayoutValues {
    struct Cell {
        static let cornerRadius: CGFloat = 12.0
    }
    struct TasteLabel {
        static let padding = UIEdgeInsets(horizontal: 8, vertical: 4)
    }
}
private struct Colors {
    struct Cell {
        static let background = UIColor(red: 153/255, green: 255/255, blue: 153/255, alpha: 0.7)
    }
    struct TasteLabel {
        static let text = UIColor.black
    }
}
private struct Fonts {
    static let taste = UIFont.appFont(size: 16, weight: .medium)
}

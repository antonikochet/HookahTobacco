//
//  TasteCollectionViewCell.swift
//  HookahTobacco
//
//  Created by антон кочетков on 13.11.2022.
//

import UIKit
import SnapKit

struct TasteCollectionCellViewModel {
    let taste: String
}

class TasteCollectionViewCell: UICollectionViewCell {
    // MARK: - Static properties
    static let identifier = NSStringFromClass(AddTastesTableViewCell.self)

    // MARK: - Public properties
    var viewModel: TasteCollectionCellViewModel! {
        didSet {
            tasteLabel.text = viewModel.taste
        }
    }

    // MARK: - Private UI
    private let tasteLabel: UILabel = {
        let label = UILabel()
        label.font = tasteFont
        label.lineBreakMode = .byWordWrapping
        label.textColor = textLabelColor
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
        backgroundColor = Self.cellBackgroundColor
        addSubview(tasteLabel)
        tasteLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Self.paddingLabel)
        }
        layer.cornerRadius = Self.cornerRadiusCell
    }
}

extension TasteCollectionViewCell {
    static let tasteFont: UIFont = UIFont.appFont(size: 16, weight: .medium)
    static let paddingLabel: UIEdgeInsets = UIEdgeInsets(horizontal: 8, vertical: 4)
    static private let cornerRadiusCell: CGFloat = 12

    static private let cellBackgroundColor: UIColor = .systemGreen
    static private let textLabelColor: UIColor = .black
}

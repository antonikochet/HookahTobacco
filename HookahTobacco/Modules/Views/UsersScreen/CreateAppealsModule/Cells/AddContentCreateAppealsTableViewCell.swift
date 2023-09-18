//
//
//  AddContentCreateAppealsTableViewCell.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 18.09.2023.
//
//

import UIKit
import IVCollectionKit

struct AddContentCreateAppealsCollectionCellItem {
    let addAction: CompletionBlock?
}

final class AddContentCreateAppealsCollectionViewCell: UICollectionViewCell, ConfigurableCollectionItem {
    // MARK: - Public properties

    // MARK: - Private UI
    private let addButton = IconButton()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        setupCell()
        setupAddButton()
    }
    private func setupCell() {
        backgroundColor = .clear
    }
    private func setupAddButton() {
        addButton.image = R.image.add()
        contentView.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
        }
    }

    // MARK: - ConfigurableCollectionItem
    func configure(item: AddContentCreateAppealsCollectionCellItem) {
        addButton.action = item.addAction
    }

    static func estimatedSize(item: AddContentCreateAppealsCollectionCellItem,
                              boundingSize: CGSize,
                              in section: AbstractCollectionSection) -> CGSize {
        CGSize(width: 30.0, height: 80.0)
    }
}

//
//
//  ContentCreateAppealsTableViewCell.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 18.09.2023.
//
//

import UIKit
import IVCollectionKit

struct ContentCreateAppealsCollectionCellItem {
    let index: Int
    let image: UIImage?
    let removeButtonAction: CompletionBlockWithParam<Int>?
}

final class ContentCreateAppealsCollectionViewCell: UICollectionViewCell, ConfigurableCollectionItem {
    // MARK: - Public properties

    // MARK: - Private properties
    private var item: ContentCreateAppealsCollectionCellItem?
    // MARK: - Private UI
    private let imageView = UIImageView()
    private let removeButton = IconButton()

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
        setupImageView()
        setupRemoveButton()
    }
    private func setupCell() {
        backgroundColor = .clear
    }
    private func setupImageView() {
        imageView.backgroundColor = R.color.inputBackground()
        imageView.layer.cornerRadius = 12.0
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
    private func setupRemoveButton() {
        removeButton.image = R.image.close()
        removeButton.size = 16.0
        removeButton.imageSize = 16.0
        contentView.addSubview(removeButton)
        removeButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }

    // MARK: - ConfigurableCollectionItem
    func configure(item: ContentCreateAppealsCollectionCellItem) {
        self.item = item
        imageView.image = item.image
        removeButton.isHidden = item.removeButtonAction == nil
        removeButton.action = { [weak self] in
            guard let item = self?.item else { return }
            item.removeButtonAction?(item.index)
        }
    }

    static func estimatedSize(item: ContentCreateAppealsCollectionCellItem,
                              boundingSize: CGSize,
                              in section: AbstractCollectionSection) -> CGSize {
        CGSize(width: 80.0, height: 80.0)
    }
}

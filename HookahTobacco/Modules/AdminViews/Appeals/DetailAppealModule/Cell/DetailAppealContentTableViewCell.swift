//
//
//  DetailAppealContentTableViewCell.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 20.09.2023.
//
//

import UIKit
import TableKit
import IVCollectionKit

struct DetailAppealContent {
    let url: String
    let data: Data

    var type: ContentType {
        url.isImageType() ? .photo : .video
    }
}

struct DetailAppealContentTableViewCellItem {
    let title: String
    let contents: [DetailAppealContent]
    let didSelect: CompletionBlockWithParam<Int>?
}

final class DetailAppealContentTableViewCell: UITableViewCell, ConfigurableCell {
    // MARK: - Public properties

    // MARK: - Private properties
    private var item: DetailAppealContentTableViewCellItem?
    private var collectionDirector: CustomCollectionDirector

    // MARK: - UI properties
    private let titleLabel = UILabel()
    private let collectionView = CustomCollectionView()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        collectionDirector = CustomCollectionDirector(collectionView: collectionView)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        setupCell()
        setupTitleLabel()
        setupCollectionView()
    }
    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    private func setupTitleLabel() {
        titleLabel.setForTitleName()
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(8.0)
        }
    }
    private func setupCollectionView() {
        contentView.addSubview(collectionView)
        collectionView.didSelect = { [weak self] indexPath in
            self?.item?.didSelect?(indexPath.row)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview().inset(8.0).priority(999)
        }
    }
    // MARK: - Private methods
    private func setupContentCollectionView(_ contents: [DetailAppealContent]) {
        collectionDirector.removeAll()

        var rows: [AbstractCollectionItem] = []

        for (index, content) in contents.enumerated() {
            guard let urlContent = URL(string: content.url) else { continue }
            var image: UIImage?
            switch content.type {
            case .photo:
                image = UIImage(data: content.data)
            case .video:
                // TODO: пофиксить показ превью видео
                image = nil
            }
            let item = ContentCreateAppealsCollectionCellItem(index: index,
                                                              image: image,
                                                              removeButtonAction: nil)
            let row = CollectionItem<ContentCreateAppealsCollectionViewCell>(item: item)
            rows.append(row)
        }

        let section = CollectionSection(items: rows)

        collectionDirector += section
        collectionDirector.reload()
    }

    // MARK: - ConfigurableCell
    func configure(with item: DetailAppealContentTableViewCellItem) {
        self.item = item
        titleLabel.text = item.title
        setupContentCollectionView(item.contents)
    }

    // MARK: - Selectors
}

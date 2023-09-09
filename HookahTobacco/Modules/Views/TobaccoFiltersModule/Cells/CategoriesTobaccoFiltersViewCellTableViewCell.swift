//
//
//  CategoriesTobaccoFiltersViewCellTableViewCell.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 30.08.2023.
//
//

import UIKit
import TableKit
import SnapKit
import IVCollectionKit

struct CategoriesTobaccoFiltersViewCellTableViewCellItem {
    let title: String
    let items: [FilterTobaccoCollectionViewCellItem]
    var didSelect: CompletionBlockWithParam<Int>?
    var clearAction: CompletionBlock?
}

final class CategoriesTobaccoFiltersViewCellTableViewCell: UITableViewCell, ConfigurableCell {
    // MARK: - Public properties
    var item: CategoriesTobaccoFiltersViewCellTableViewCellItem?

    // MARK: - Private properties
    private let collectionDirector: CustomCollectionDirector

    // MARK: - UI properties
    private let titleLabel = UILabel()
    private let collectionView = CustomCollectionView()
    private let clearButton = UIButton()
    private let separatorView = UIView()

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
        setupClearButton()
        setupCollectionView()
        setupSeparatorView()
    }

    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    private func setupClearButton() {
        clearButton.setTitle(R.string.localizable.generalClear(), for: .normal)
        clearButton.setTitleColor(R.color.secondarySubtitle(), for: .normal)
        clearButton.addTarget(self, action: #selector(touchClearButton), for: .touchUpInside)
        clearButton.isHidden = true
        contentView.addSubview(clearButton)
        clearButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(8.0)
            make.width.equalTo(100)
        }
    }
    private func setupTitleLabel() {
        titleLabel.textColor = R.color.primaryTitle()
        titleLabel.font = UIFont.appFont(size: 18.0, weight: .semibold)
        titleLabel.numberOfLines = 1
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
            make.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            make.leading.trailing.equalToSuperview().inset(8.0)
            make.bottom.equalToSuperview().inset(16.0).priority(999)
        }
    }
    private func setupSeparatorView() {
        separatorView.backgroundColor = R.color.fourthBackground()
        contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1.0)
        }
    }

    // MARK: - Private methods
    private func setupContentCollectionView(_ items: [FilterTobaccoCollectionViewCellItem]) {
        collectionDirector.removeAll()

        var rows: [AbstractCollectionItem] = []

        for item in items {
            let row = CollectionItem<FilterTobaccoCollectionViewCell>(item: item)
            rows.append(row)
        }

        let section = CollectionSection(items: rows)

        collectionDirector += section
        collectionDirector.reload()
    }

    // MARK: - ConfigurableCell
    func configure(with viewModel: CategoriesTobaccoFiltersViewCellTableViewCellItem) {
        self.item = viewModel
        titleLabel.text = viewModel.title
        clearButton.isHidden = viewModel.clearAction == nil
        setupContentCollectionView(viewModel.items)
    }

    // MARK: - Selectors
    @objc private func touchClearButton() {
        item?.clearAction?()
    }
}

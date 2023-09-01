//
//
//  MultiSegmentedTobaccoTableViewCell.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 01.09.2023.
//
//

import UIKit
import TableKit
import SnapKit
import MultiSelectSegmentedControl

struct MultiSegmentedTobaccoTableViewCellItem {
    let title: String
    let itemsSegment: [String]
    let selectItems: [Int]
    var didSelect: CompletionBlockWithParam<Int>?
}

final class MultiSegmentedTobaccoTableViewCell: UITableViewCell, ConfigurableCell {
    // MARK: - Public properties
    var item: MultiSegmentedTobaccoTableViewCellItem?

    // MARK: - UI properties
    private let titleLabel = UILabel()
    private let segmentedControl = MultiSelectSegmentedControl()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Setup UI
    private func setupUI() {
        setupCell()
        setupTitleLabel()
        setupSegmentedCotrol()
    }

    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    private func setupTitleLabel() {
        titleLabel.textColor = .black
        titleLabel.font = UIFont.appFont(size: 18.0, weight: .semibold)
        titleLabel.numberOfLines = 1
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(8.0)
        }
    }
    private func setupSegmentedCotrol() {
        contentView.addSubview(segmentedControl)
        segmentedControl.selectedBackgroundColor = .purple
        segmentedControl.tintColor = .purple
        segmentedControl.delegate = self
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            make.leading.trailing.equalToSuperview().inset(36.0)
            make.bottom.equalToSuperview().inset(16.0)
        }
    }

    // MARK: - ConfigurableCell
    func configure(with item: MultiSegmentedTobaccoTableViewCellItem) {
        self.item = item
        titleLabel.text = item.title
        segmentedControl.items = item.itemsSegment
        segmentedControl.selectedSegmentIndexes = IndexSet(item.selectItems)
    }
}

extension MultiSegmentedTobaccoTableViewCell: MultiSelectSegmentedControlDelegate {
    func multiSelect(_ multiSelectSegmentedControl: MultiSelectSegmentedControl,
                     didChange value: Bool,
                     at index: Int) {
        item?.didSelect?(index)
    }
}

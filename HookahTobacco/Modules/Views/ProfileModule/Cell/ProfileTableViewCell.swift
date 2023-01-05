//
//
//  ProfileTableViewCell.swift
//  HookahTobacco
//
//  Created by антон кочетков on 05.01.2023.
//
//

import UIKit
import TableKit

struct ProfileTableViewCellItem {
    let photo: Data?
    let name: String
}

final class ProfileTableViewCell: UITableViewCell, ConfigurableCell {
    // MARK: - Public properties

    // MARK: - UI properties
    private let photoView = UIImageView()
    private let nameLabel = UILabel()

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
        setupPhotoView()
        setupNameLabel()
    }

    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
    }

    private func setupPhotoView() {
        contentView.addSubview(photoView)
        photoView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(LayoutValues.PhotoView.padding)
            make.size.equalTo(LayoutValues.PhotoView.size)
        }
        photoView.contentMode = .scaleAspectFit
    }

    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(photoView.snp.trailing).offset(LayoutValues.NameLabel.leading)
            make.top.trailing.bottom.equalToSuperview().inset(LayoutValues.NameLabel.padding)
        }
        nameLabel.textColor = Colors.nameText
        nameLabel.font = Fonts.name
        nameLabel.numberOfLines = 1
    }

    // MARK: - ConfigurableCell
    func configure(with item: ProfileTableViewCellItem) {
        if let photo = item.photo {
            photoView.image = UIImage(data: photo)
        } else {
            photoView.image = Images.defaultPhoto
        }
        nameLabel.text = item.name
    }

    static var estimatedHeight: CGFloat? {
        LayoutValues.Cell.estimatedHeight
    }
}

private struct LayoutValues {
    struct Cell {
        static let estimatedHeight: CGFloat = 100.0
    }
    struct PhotoView {
        static let padding: CGFloat = 8.0
        static let size: CGFloat = Cell.estimatedHeight - padding * 2.0
    }
    struct NameLabel {
        static let leading: CGFloat = 16.0
        static let padding: CGFloat = 8.0
    }
}
private struct Images {
    static let defaultPhoto = UIImage(systemName: "person.circle.fill")!
}
private struct Colors {
    static let nameText: UIColor = .label
}
private struct Fonts {
    static let name = UIFont.appFont(size: 16, weight: .medium)
}

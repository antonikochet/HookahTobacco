//
//  EmptyCell.swift
//  HookahTobacco
//
//  Created by антон кочетков on 01.11.2022.
//

import UIKit
import SnapKit

class EmptyCell: UITableViewCell {
    // MARK: - Static properties
    static let identifier = NSStringFromClass(EmptyCell.self)
    static let heightCell: CGFloat = 200
    
    // MARK: - Public properties
    var title: String? {
        didSet { titleLabel.text = title }
    }
    
    var descriptionText: String? {
        didSet {
            descriptionLabel.text = descriptionText
            descriptionLabel.snp.updateConstraints { make in
                make.height.equalTo(descriptionText != nil ? descriptionHeight : 0)
            }
            iconImageView.snp.updateConstraints { make in
                make.height.equalTo(iconImageHeight)
            }
        }
    }
    
    // MARK: - Private properties
    private var iconImageHeight: CGFloat {
        EmptyCell.heightCell -
        8.0 -
        //iconImage
        8.0 -
        titleLabel.font.lineHeight + 2.0 - 8.0 -
        descriptionHeight
    }
    
    private var descriptionHeight: CGFloat {
        descriptionText?.height(width: contentView.frame.width - 16, font: descriptionLabel.font) ?? 0
    }
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        imageView.image = UIImage(systemName: "magnifyingglass.circle")?.withRenderingMode(.alwaysTemplate)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.appFont(size: 26, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.appFont(size: 18, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(0)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(titleLabel.font.lineHeight + 2)
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(0)
        }
    }
}

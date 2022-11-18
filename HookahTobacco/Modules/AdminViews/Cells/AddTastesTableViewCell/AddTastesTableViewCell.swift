//
//  AddTastesTableViewCell.swift
//  HookahTobacco
//
//  Created by антон кочетков on 13.11.2022.
//

import UIKit
import SnapKit

struct AddTastesTableCellViewModel {
    let taste: String
    let id: String
    let typeTaste: String
    let isSelect: Bool
}

class AddTastesTableViewCell: UITableViewCell {

    // MARK: - Static properties
    static let identifier = NSStringFromClass(AddTastesTableViewCell.self)

    // MARK: - Public properties
    var viewModel: AddTastesTableCellViewModel? {
        didSet {
            updateContentCell()
        }
    }
    //MARK: - Private properties
    private var checkmarkWidthConstraint: Constraint?
    
    //MARK: - Private UI
    private let idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 18, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    private let tasteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 22, weight: .medium)
        label.numberOfLines = 0
        return label
    }()

    private let typeTasteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 16, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()

    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        return imageView
    }()

    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    //MARK: - Setup
    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(idLabel)
        idLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.15)
        }
        
        contentView.addSubview(tasteLabel)
        tasteLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(idLabel.snp.trailing)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        contentView.addSubview(checkmarkImageView)
        checkmarkImageView.snp.makeConstraints { make in
            make.height.equalToSuperview().inset(4)
            checkmarkWidthConstraint = make.width.equalTo(checkmarkImageView.snp.height).constraint
            make.width.equalTo(0).priority(.medium)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(4)
        }
        contentView.addSubview(typeTasteLabel)
        typeTasteLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(tasteLabel.snp.trailing)
            make.trailing.equalTo(checkmarkImageView.snp.leading).inset(-4)
        }
    }
    
    //MARK: - Private methods
    private func updateContentCell() {
        if let viewModel = viewModel {
            idLabel.text = viewModel.id
            tasteLabel.text = viewModel.taste
            typeTasteLabel.text = viewModel.typeTaste
            checkmarkImageView.image = viewModel.isSelect ? UIImage(systemName: "checkmark.circle.fill")?.withRenderingMode(.alwaysTemplate) : nil
            checkmarkWidthConstraint?.isActive = viewModel.isSelect
        }
    }
    
}

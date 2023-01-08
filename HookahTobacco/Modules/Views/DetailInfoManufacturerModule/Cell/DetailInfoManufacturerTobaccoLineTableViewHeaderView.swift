//
//  DetailInfoManufacturerTobaccoLineTableViewHeaderView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 08.01.2023.
//

import UIKit
import SnapKit

final class DetailInfoManufacturerTobaccoLineTableViewHeaderView: UIView {
    // MARK: - Public properties
    var text: String = "" {
        didSet {
            label.text = text
        }
    }

    // MARK: - UI properties
    private let label = UILabel()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Setup
    private func setupUI() {
        setupView()
        setupLabel()
    }
    private func setupView() {
        backgroundColor = Colors.View.background
    }
    private func setupLabel() {
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = Fonts.label

        addSubview(label)
        label.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(LayoutValues.Label.padding)
            make.left.equalToSuperview().offset(LayoutValues.Label.left)
        }
    }
}

private struct LayoutValues {
    struct Label {
        static let left: CGFloat = 32.0
        static let padding: CGFloat = 8.0
    }
}
private struct Images { }
private struct Colors {
    struct View {
        static let background = UIColor(white: 0.8, alpha: 1.0)
    }
    struct Label {
        static let text = UIColor(white: 0.3, alpha: 1.0)
    }
}
private struct Fonts {
    static let label = UIFont.appFont(size: 24.0, weight: .medium)
}

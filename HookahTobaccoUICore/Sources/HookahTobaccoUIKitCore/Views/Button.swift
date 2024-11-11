//
//  Button.swift
//
//
//  Created by Anton Kochetkov on 11.09.2023.
//

import UIKit
import SnapKit
import HookahTobaccoResources

extension Button {
    public enum Style {
        case primary
        case secondary
        case third
        case stroke
        case fill

        var backgroundColor: UIColor? {
            switch self {
            case .primary, .secondary, .third, .stroke:
                return .clear
            case .fill:
                return ResourceManager.provider.color(forKey: .primaryPurple).colorUIKit
            }
        }

        var tintColor: UIColor? {
            switch self {
            case .primary, .stroke:
                return ResourceManager.provider.color(forKey: .primarySubtitle).colorUIKit
            case .secondary:
                return ResourceManager.provider.color(forKey: .secondarySubtitle).colorUIKit
            case .third:
                return ResourceManager.provider.color(forKey: .primaryPurple).colorUIKit
            case .fill:
                return ResourceManager.provider.color(forKey: .primaryWhite).colorUIKit
            }
        }

        var borderColor: CGColor? {
            switch self {
            case .stroke:
                return ResourceManager.provider.color(forKey: .primaryPurple).colorUIKit?.cgColor
            default:
                return nil
            }
        }

        var borderWidth: CGFloat {
            switch self {
            case .stroke:
                return 2.0
            default:
                return 0.0
            }
        }
    }
}

public final class Button: UIView {

    // MARK: - Public properties
    public var action: VoidBlock?

    public var isEnabled: Bool = true {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }

    public override var intrinsicContentSize: CGSize {
        stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize) + LayoutValues.edgesStackView
    }

    // MARK: - Private properties
    private var style: Style

    // MARK: - Private UI
    private let stackView = UIStackView()
    private let iconView = IconView()
    private let labelView = UILabel()

    // MARK: - Init
    public init(style: Style) {
        self.style = style
        super.init(frame: .zero)
        setupUI()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        setupView()
        setupStackView()
        setupIconView()
        setupLabelView()
        setupAction()
        setupStyle()
    }
    private func setupView() {
        layer.cornerRadius = 8.0
    }
    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 4.0
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(LayoutValues.edgesStackView)
        }
    }
    private func setupIconView() {
        iconView.isHidden = true
        stackView.addArrangedSubview(iconView)
    }
    private func setupLabelView() {
        labelView.isHidden = true
        labelView.font = UIFont.appFont(size: 17.0, weight: .semibold)
        labelView.textAlignment = .center
        labelView.numberOfLines = 0
        stackView.addArrangedSubview(labelView)
    }
    private func setupAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapPressed))
        addGestureRecognizer(tap)
    }

    // MARK: - Public methods
    public func setStyle(_ style: Style) {
        self.style = style
        setupStyle()
    }

    public func setTitle(_ title: String?) {
        labelView.text = title
        labelView.isHidden = title == nil
    }

    public func setImage(_ image: UIImage?, imageSize: CGFloat? = nil, isUseTintColor: Bool = false) {
        iconView.image = image
        iconView.isHidden = image == nil
        if let imageSize {
            iconView.size = imageSize
            iconView.imageSize = imageSize
        }
        if isUseTintColor {
            iconView.imageColor = style.tintColor
        }
    }

    // MARK: - Private methods
    private func setupStyle() {
        backgroundColor = style.backgroundColor
        labelView.textColor = style.tintColor
        layer.borderColor = style.borderColor
        layer.borderWidth = style.borderWidth
    }

    // MARK: - Selectors
    @objc private func tapPressed() {
        if isEnabled {
            action?()
        }
    }
}

private struct LayoutValues {
    static let edgesStackView = UIEdgeInsets(horizontal: 8.0, vertical: 4.0)
}

//
//
//  DetailTobaccoViewController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 25.11.2022.
//
//

import UIKit
import SnapKit

struct DetailTobaccoViewModel {
    let image: Data?
    let name: String
    let nameManufacturer: String
    let description: String?
    let info: [DescriptionStackViewItem]
}

protocol DetailTobaccoViewInputProtocol: AnyObject {
    func setupContent(_ viewModel: DetailTobaccoViewModel)
    func setupTasteView()
}

protocol DetailTobaccoViewOutputProtocol: AnyObject {
    var tasteNumberOfRows: Int { get }
    func getTasteViewModel(at index: Int) -> TasteCollectionCellViewModel
    func viewDidLoad()
}

class DetailTobaccoViewController: HTScrollContentViewController {
    // MARK: - Public properties
    var presenter: DetailTobaccoViewOutputProtocol!

    // MARK: - UI properties
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let tasteCollectionView = TasteCollectionView()
    private let infoStackView = UIStackView()
    private let descriptionLabel = UILabel()
    private let nameManufacturerLabel = UILabel()
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setup()
        presenter.viewDidLoad()
    }

    // MARK: - Setups
    private func setup() {
        setupSubviews()
        setupImages()
        setupNameLabel()
        setupTasteCollectionView()
        setupInfoStackView()
        setupDescriptionLabel()
        setupManufacturerLabel()
        setupConstrainsScrollView()
    }
    private func setupImages() {
        imageView.contentMode = .scaleAspectFit

        contentScrollView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutValues.ImageView.top)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.ImageView.horizPadding)
            make.height.equalTo(imageView.snp.width)
        }
    }
    private func setupNameLabel() {
        nameLabel.font = Fonts.name
        nameLabel.textAlignment = .center
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.7
        nameLabel.numberOfLines = 0

        contentScrollView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(LayoutValues.NameLabel.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(nameLabel.font.lineHeight)
        }
    }
    private func setupTasteCollectionView() {
        contentScrollView.addSubview(tasteCollectionView)
        tasteCollectionView.tasteDelegate = self

        tasteCollectionView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(LayoutValues.TasteCollectionView.top)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.TasteCollectionView.horizPadding)
        }
    }
    private func setupInfoStackView() {
        infoStackView.axis = .vertical
        infoStackView.spacing = LayoutValues.InfoStackView.spacing
        infoStackView.distribution = .fillProportionally

        contentScrollView.addSubview(infoStackView)
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(tasteCollectionView.snp.bottom).offset(LayoutValues.InfoStackView.top)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.InfoStackView.horizPadding)
        }
    }
    private func setupDescriptionLabel() {
        descriptionLabel.font = Fonts.description
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0

        contentScrollView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(infoStackView.snp.bottom).offset(LayoutValues.DescriptionLabel.top)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.DescriptionLabel.horizPadding)
            make.height.equalTo(0)
        }
    }
    private func setupManufacturerLabel() {
        nameManufacturerLabel.font = Fonts.nameManufacturer
        nameManufacturerLabel.textAlignment = .right
        nameManufacturerLabel.numberOfLines = 1

        contentScrollView.addSubview(nameManufacturerLabel)
        nameManufacturerLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(LayoutValues.NameManufacturerLabel.top)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.NameManufacturerLabel.horizPadding)
            make.bottom.equalToSuperview().inset(LayoutValues.NameManufacturerLabel.bottom)
        }
    }

    // MARK: - Private methods
    private func configureInfoStackView(with viewModel: DetailTobaccoViewModel) {
        for subview in infoStackView.arrangedSubviews {
            infoStackView.removeArrangedSubview(subview)
        }
        for item in viewModel.info {
            let stackView = DescriptionStackView()
            stackView.configure(with: item)
            infoStackView.addArrangedSubview(stackView)
        }
    }
    // MARK: - Selectors

}

// MARK: - ViewInputProtocol implementation
extension DetailTobaccoViewController: DetailTobaccoViewInputProtocol {
    func setupContent(_ viewModel: DetailTobaccoViewModel) {
        if let image = viewModel.image {
            imageView.image = UIImage(data: image)
        }
        nameLabel.text = viewModel.name
        configureInfoStackView(with: viewModel)
        descriptionLabel.text = viewModel.description
        descriptionLabel.snp.updateConstraints { make in
            make.height.equalTo(viewModel.description?.height(width: view.frame.width - (sideSpacingConstraint + 2),
                                                              font: descriptionLabel.font) ?? 0)
        }
        nameManufacturerLabel.text = viewModel.nameManufacturer
    }

    func setupTasteView() {
        tasteCollectionView.reloadData()
    }
}

// MARK: - TasteCollectionViewDelegate implementation
extension DetailTobaccoViewController: TasteCollectionViewDelegate {
    func getItem(at index: Int) -> TasteCollectionCellViewModel {
        presenter.getTasteViewModel(at: index)
    }

    var numberOfRows: Int {
        presenter.tasteNumberOfRows
    }

    func didSelectTaste(at index: Int) {

    }
}

private struct LayoutValues {
    struct ImageView {
        static let top: CGFloat = 16.0
        static let horizPadding: CGFloat = 16.0
    }
    struct NameLabel {
        static let top: CGFloat = 16.0
    }
    struct TasteCollectionView {
        static let top: CGFloat = 16.0
        static let horizPadding: CGFloat = 32.0
    }
    struct InfoStackView {
        static let spacing: CGFloat = 16.0
        static let top: CGFloat = 16.0
        static let horizPadding: CGFloat = 32.0
    }
    struct DescriptionLabel {
        static let top: CGFloat = 16.0
        static let horizPadding: CGFloat = 32.0
    }
    struct NameManufacturerLabel {
        static let top: CGFloat = 16.0
        static let horizPadding: CGFloat = 32.0
        static let bottom: CGFloat = 16.0
    }
}
private struct Fonts {
    static let name = UIFont.appFont(size: 30, weight: .bold)
    static let description = UIFont.appFont(size: 16, weight: .regular)
    static let nameManufacturer = UIFont.appFont(size: 28, weight: .bold)
}

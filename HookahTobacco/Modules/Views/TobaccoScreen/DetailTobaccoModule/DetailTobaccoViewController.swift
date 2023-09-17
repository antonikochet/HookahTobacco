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
    func getTasteCollectionView() -> CustomCollectionView
    func setupContent(_ viewModel: DetailTobaccoViewModel)
}

protocol DetailTobaccoViewOutputProtocol: AnyObject {
    func viewDidLoad()
}

class DetailTobaccoViewController: HTScrollContentViewController {
    // MARK: - Public properties
    var presenter: DetailTobaccoViewOutputProtocol!

    // MARK: - UI properties
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let tasteCollectionView = CustomCollectionView()
    private let infoStackView = UIStackView()
    private let descriptionLabel = UILabel()
    private let nameManufacturerLabel = UILabel()

    override var stackViewInset: UIEdgeInsets {
        UIEdgeInsets(horizontal: 16.0, vertical: 16.0)
    }

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.color.primaryBackground()

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
        setupConstrainsScrollView(top: view.safeAreaLayoutGuide.snp.top,
                                  bottom: view.safeAreaLayoutGuide.snp.bottom)
    }
    private func setupImages() {
        let view = UIView()
        stackView.addArrangedSubview(view)
        view.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(view.snp.width)
        }

        imageView.contentMode = .scaleAspectFit

        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.height.equalTo(imageView.snp.width)
        }
    }
    private func setupNameLabel() {
        nameLabel.font = UIFont.appFont(size: 30, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.7
        nameLabel.numberOfLines = 0

        stackView.addArrangedSubview(nameLabel)
    }
    private func setupTasteCollectionView() {
        stackView.addArrangedSubview(tasteCollectionView)
    }
    private func setupInfoStackView() {
        infoStackView.axis = .vertical
        infoStackView.spacing = 16.0
        infoStackView.distribution = .fillProportionally

        stackView.addArrangedSubview(infoStackView)
    }
    private func setupDescriptionLabel() {
        descriptionLabel.font = UIFont.appFont(size: 16, weight: .regular)
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0

        stackView.addArrangedSubview(descriptionLabel)
    }
    private func setupManufacturerLabel() {
        nameManufacturerLabel.font = UIFont.appFont(size: 28, weight: .bold)
        nameManufacturerLabel.textAlignment = .right
        nameManufacturerLabel.numberOfLines = 1

        stackView.addArrangedSubview(nameManufacturerLabel)
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
    func getTasteCollectionView() -> CustomCollectionView {
        tasteCollectionView
    }

    func setupContent(_ viewModel: DetailTobaccoViewModel) {
        if let image = viewModel.image {
            imageView.image = UIImage(data: image)
        }
        nameLabel.text = viewModel.name
        configureInfoStackView(with: viewModel)
        descriptionLabel.text = viewModel.description
        nameManufacturerLabel.text = viewModel.nameManufacturer
    }
}

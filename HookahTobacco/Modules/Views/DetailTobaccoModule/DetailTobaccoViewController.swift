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

protocol DetailTobaccoViewInputProtocol: AnyObject {
    func setupContent(_ viewModel: DetailTobaccoEntity.ViewModel)
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

    override var contentViewHeight: CGFloat {
        imageView.frame.height +
        nameLabel.frame.height +
        tasteCollectionView.contentSize.height +
        descriptionLabel.frame.height +
        nameManufacturerLabel.frame.height +
        spacingBetweenViews * 6
    }

    // MARK: - UI properties
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 30, weight: .bold)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.numberOfLines = 0
        return label
    }()

    private let tasteCollectionView = TasteCollectionView()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 16, weight: .regular)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    private let nameManufacturerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 28, weight: .bold)
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupSubviews()
        presenter.viewDidLoad()
    }

    // MARK: - Setups
    override func setupSubviews() {
        super.setupSubviews()
        setupImages()

        contentScrollView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(nameLabel.font.lineHeight)
        }

        contentScrollView.addSubview(tasteCollectionView)
        tasteCollectionView.tasteDelegate = self
        tasteCollectionView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }

        contentScrollView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(tasteCollectionView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
            make.height.equalTo(0)
        }

        contentScrollView.addSubview(nameManufacturerLabel)
        nameManufacturerLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
            make.height.equalTo(nameManufacturerLabel.font.lineHeight)
        }

        setupConstrainsScrollView()
    }

    private func setupImages() {
        contentScrollView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(spacingBetweenViews)
            make.height.equalTo(imageView.snp.width)
        }
    }
    // MARK: - Private methods

    // MARK: - Selectors

}

// MARK: - ViewInputProtocol implementation
extension DetailTobaccoViewController: DetailTobaccoViewInputProtocol {
    func setupContent(_ viewModel: DetailTobaccoEntity.ViewModel) {
        if let image = viewModel.image {
            imageView.image = UIImage(data: image)
        }
        nameLabel.text = viewModel.name
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

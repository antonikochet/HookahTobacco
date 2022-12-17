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
        nameLineLabel.frame.height +
        packetingFormatLabel.frame.height +
        tobaccoTypeLabel.frame.height +
        tobaccoLeafTypeLabel.frame.height +
        descriptionLabel.frame.height +
        nameManufacturerLabel.frame.height +
        spacingBetweenViews * (8 +
                               (nameLineLabel.isHidden ? 0 : 1) +
                               (tobaccoLeafTypeLabel.isHidden ? 0 : 1)
        )
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

    private let nameLineLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(size: 16, weight: .regular)
        label.isHidden = true
        label.numberOfLines = 1
        return label
    }()

    private let packetingFormatLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(size: 16, weight: .regular)
        return label
    }()

    private let tobaccoTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(size: 16, weight: .medium)
        return label
    }()

    private let tobaccoLeafTypeLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = .appFont(size: 16, weight: .regular)
        return label
    }()

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
        let imageView = setupImages()

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

        let bottomTobaccoLineView = setupTobaccoLine(tasteCollectionView)

        contentScrollView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(bottomTobaccoLineView.snp.bottom).offset(spacingBetweenViews)
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

    private func setupImages() -> UIView {
        contentScrollView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(spacingBetweenViews)
            make.height.equalTo(imageView.snp.width)
        }

        return imageView
    }

    private func setupTobaccoLine(_ topView: UIView) -> UIView {
        contentScrollView.addSubview(nameLineLabel)
        nameLineLabel.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
            make.height.equalTo(0)
        }

        contentScrollView.addSubview(packetingFormatLabel)
        packetingFormatLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLineLabel.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
            make.height.equalTo(packetingFormatLabel.font.lineHeight)
        }

        contentScrollView.addSubview(tobaccoTypeLabel)
        tobaccoTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(packetingFormatLabel.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
            make.height.equalTo(tobaccoTypeLabel.font.lineHeight)
        }

        contentScrollView.addSubview(tobaccoLeafTypeLabel)
        tobaccoLeafTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(tobaccoTypeLabel.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
            make.height.equalTo(0)
        }

        return tobaccoLeafTypeLabel
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
        nameLineLabel.isHidden = viewModel.nameLine == nil
        nameLineLabel.text = viewModel.nameLine
        nameLineLabel.snp.updateConstraints {
            $0.height.equalTo(nameLineLabel.isHidden ? 0 : nameLineLabel.font.lineHeight) }
        packetingFormatLabel.text = viewModel.packetingFormat
        tobaccoTypeLabel.text = viewModel.tobaccoType
        tobaccoLeafTypeLabel.isHidden = viewModel.tobaccoLeafType == nil
        tobaccoLeafTypeLabel.text = viewModel.tobaccoLeafType
        tobaccoLeafTypeLabel.snp.updateConstraints {
            $0.height.equalTo(tobaccoLeafTypeLabel.isHidden ? 0 : tobaccoLeafTypeLabel.font.lineHeight) }
        descriptionLabel.text = viewModel.description
        descriptionLabel.snp.updateConstraints { make in
            make.height.equalTo(viewModel.description?.height(width: view.frame.width - (sideSpacingConstraint + 2),
                                                              font: descriptionLabel.font) ?? 0)
        }
        nameManufacturerLabel.text = viewModel.nameManufacturer
        contentScrollView.layoutIfNeeded()
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

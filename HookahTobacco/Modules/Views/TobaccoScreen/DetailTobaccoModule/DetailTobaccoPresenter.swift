//
//
//  DetailTobaccoPresenter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 25.11.2022.
//
//

import Foundation
import IVCollectionKit

class DetailTobaccoPresenter {
    // MARK: - Public properties
    weak var view: DetailTobaccoViewInputProtocol!
    var interactor: DetailTobaccoInteractorInputProtocol!
    var router: DetailTobaccoRouterProtocol!

    // MARK: - Private properties
    private var tasteDirector: CustomCollectionDirector?

    // MARK: - Private methods
    private func createTasteViewModel(_ taste: Taste) -> TasteCollectionCellViewModel {
        TasteCollectionCellViewModel(label: taste.taste)
    }

    private func createViewModel(_ tobacco: Tobacco) -> DetailTobaccoViewModel {
        let description = (!tobacco.description.isEmpty ?
                           R.string.localizable.detailTobaccoDescriptionTitle(tobacco.description) :
                            nil)
        let packetingFormat = tobacco.line.packetingFormat.compactMap {
            String($0) + R.string.localizable.generalGram()
        }.joined(separator: ", ")
        let tobaccoLeafType = (tobacco.line.tobaccoType.rawValue == TobaccoType.tobacco.rawValue ?
                               tobacco.line.tobaccoLeafType?.map { $0.name }.joined(separator: ", ") :
                                nil)
        var info: [DescriptionStackViewItem] = []
        if !tobacco.line.isBase {
            info.append(DescriptionStackViewItem(name: R.string.localizable.detailTobaccoNameLineTitle(),
                                                 description: tobacco.line.name))
        }
        info.append(DescriptionStackViewItem(name: R.string.localizable.detailTobaccoPackagingFormatTitle(),
                                             description: packetingFormat))
        info.append(DescriptionStackViewItem(name: R.string.localizable.detailTobaccoTobaccoTypeTitle(),
                                             description: tobacco.line.tobaccoType.name))
        if let tobaccoLeafType {
            info.append(DescriptionStackViewItem(name: R.string.localizable.detailTobaccoTobaccoLeafTypeTitle(),
                                                 description: tobaccoLeafType))
        }

        return DetailTobaccoViewModel(
            image: tobacco.image,
            name: tobacco.name,
            nameManufacturer: tobacco.nameManufacturer,
            description: description,
            info: info
        )
    }

    private func setupCollectionView(_ tastes: [Taste]) {
        guard let tasteDirector else { return }
        tasteDirector.sections.removeAll()
        var rows: [AbstractCollectionItem] = []

        for taste in tastes {
            let item = TasteCollectionCellViewModel(label: taste.taste)
            let row = CollectionItem<TasteCollectionViewCell>(item: item)
            rows.append(row)
        }

        let section = CollectionSection(items: rows)

        tasteDirector += section
        tasteDirector.reload()
    }

}

// MARK: - InteractorOutputProtocol implementation
extension DetailTobaccoPresenter: DetailTobaccoInteractorOutputProtocol {
    func receivedError(_ error: HTError) {
        router.showError(with: error.message)
    }

    func initialDataForPresentation(_ tobacco: Tobacco) {
        let viewModel = createViewModel(tobacco)
        view.setupContent(viewModel)
        setupCollectionView(tobacco.tastes)
    }
}

// MARK: - ViewOutputProtocol implementation
extension DetailTobaccoPresenter: DetailTobaccoViewOutputProtocol {
    func viewDidLoad() {
        let tasteCollectionView = view.getTasteCollectionView()
        tasteDirector = CustomCollectionDirector(collectionView: tasteCollectionView)
        interactor.receiveStartingDataView()
    }
}

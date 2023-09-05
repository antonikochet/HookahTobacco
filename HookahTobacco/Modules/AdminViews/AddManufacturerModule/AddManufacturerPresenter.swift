//
//
//  AddManufacturerPresenter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import Foundation
import IVCollectionKit

class AddManufacturerPresenter {
    // MARK: - Public properties
    weak var view: AddManufacturerViewInputProtocol!
    var interactor: AddManufacturerInteractorInputProtocol!
    var router: AddManufacturerRouterProtocol!

    // MARK: - Private properties
    private var tobaccoLinesDirector: CustomCollectionDirector?
    private var tobaccoLinesViewModels: [TasteCollectionCellViewModel] = []
    private var countries: [String] = []
    private var isImage: Bool = false
    private var editingTobaccoLineIndex: Int?

    // MARK: - Private methods
    private func setupTobaccoLineCollectionView(_ tobaccoLines: [TobaccoLine]) {
        guard let tobaccoLinesDirector else { return }
        tobaccoLinesDirector.sections.removeAll()
        tobaccoLinesViewModels.removeAll()

        var rows: [AbstractCollectionItem] = []

        for line in tobaccoLines {
            let item = TasteCollectionCellViewModel(
                label: line.isBase ? R.string.localizable.generalBasicLine() : line.name
            )
            tobaccoLinesViewModels.append(item)
            let row = CollectionItem<TasteCollectionViewCell>(item: item)
            rows.append(row)
        }

        let section = CollectionSection(items: rows)

        tobaccoLinesDirector += section
        tobaccoLinesDirector.reload()
    }
}

// MARK: - InteractorOutputProtocol implementation
extension AddManufacturerPresenter: AddManufacturerInteractorOutputProtocol {
    func receivedSuccessAddition() {
        view.hideLoading()
        tobaccoLinesViewModels = []
        view.clearView()
        setupTobaccoLineCollectionView([])
        showCountryForSelect(nil)
        router.showSuccess(delay: 2.0)
    }

    func receivedSuccessEditing(with changedData: Manufacturer) {
        view.hideLoading()
        router.showSuccess(delay: 2.0) { [weak self] in
            self?.router.dismissView(with: changedData)
        }
    }

    func receivedError(with message: String) {
        view.hideLoading()
        router.showError(with: message)
    }

    func receivedError(_ error: HTError) {
        view.hideLoading()
        router.showError(with: error.message)
    }

    func initialDataForPresentation(_ manufacturer: AddManufacturerEntity.Manufacturer, isEditing: Bool) {
        let viewModel = AddManufacturerEntity.ViewModel(
                            name: manufacturer.name,
                            description: manufacturer.description ?? "",
                            textButton: (isEditing ?
                                            R.string.localizable.addManufacturerAddButtonEditTitle() :
                                            R.string.localizable.addManufacturerAddButtonAddTitle()),
                            link: manufacturer.link ?? "",
                            isEnabledAddTobaccoLine: isEditing)
        view.setupContent(viewModel)
    }

    func initialImage(_ image: Data?) {
        if let image = image {
            view.setupImageManufacturer(image)
            isImage = true
        } else {
            view.setupImageManufacturer(nil)
            isImage = false
        }
    }

    func initialTobaccoLines(_ lines: [TobaccoLine]) {
        setupTobaccoLineCollectionView(lines)
    }

    func changeTobaccoLine(for id: Int, _ line: TobaccoLine) {
        let name = line.isBase ? R.string.localizable.generalBasicLine() : line.name
        editingTobaccoLineIndex = tobaccoLinesViewModels.firstIndex(where: { $0.label == name })
        router.showAddTobaccoLineView(for: id, editing: line, delegate: self)
    }

    func initialCounties(_ countries: [Country]) {
        self.countries = countries.map { $0.name }
        if self.countries.isEmpty {
            self.countries.insert(R.string.localizable.generalAbsent(), at: 0)
            showCountryForSelect(R.string.localizable.generalAbsent())
        } else {
            self.countries.insert(.dash, at: 0)
            showCountryForSelect(.dash)
        }
    }

    func showCountryForSelect(_ country: String?) {
        if let country,
           let index = countries.firstIndex(of: country) {
            view.setupSelectedCountry(index)
        } else {
            view.setupSelectedCountry(0)
        }
    }
}

// MARK: - ViewOutputProtocol implementation
extension AddManufacturerPresenter: AddManufacturerViewOutputProtocol {
    func pressedAddButton(with enteredData: AddManufacturerEntity.EnterData) {
        guard let name = enteredData.name, !name.isEmpty else {
            router.showError(with: R.string.localizable.addManufacturerNameEmptyMessage())
            return
        }
        guard isImage else {
            router.showError(with: R.string.localizable.addManufacturerImageEmptyMessage())
            return
        }

        let data = AddManufacturerEntity.Manufacturer(
                        name: name,
                        description: enteredData.description,
                        link: enteredData.link)

        view.showLoading()
        interactor.didEnterDataManufacturer(data)
    }

    func selectedImage(with urlFile: URL) {
        interactor.didSelectImage(with: urlFile)
        isImage = true
    }

    func viewDidLoad() {
        let collectionView = view.getTobaccoLineCollectionView()
        collectionView.didSelect = { [weak self] indexPath in
            self?.editingTobaccoLineIndex = indexPath.row
            self?.interactor.receiveEditingTobaccoLine(at: indexPath.row)
        }
        tobaccoLinesDirector = CustomCollectionDirector(collectionView: collectionView)
        interactor.receiveStartingDataView()
    }

    func pressedAddTobaccoLine() {
        guard let id = interactor.manufacturerId else {
            router.showError(with: R.string.localizable.addManufacturerNotIdManufacturerEmptyMessage())
            return
        }
        editingTobaccoLineIndex = nil
        router.showAddTobaccoLineView(for: id, editing: nil, delegate: self)
    }

    func pressedAddCountry() {
        router.showAddCountryView(delegate: self)
    }

    func numberOfRowsCountries() -> Int {
        return countries.count
    }

    func receiveRowCountry(by index: Int) -> String {
        guard index < countries.count else {
            return R.string.localizable.generalAbsent()
        }
        return countries[index]
    }

    func receiveIndexRowCountry(for title: String) -> Int {
        countries.firstIndex(of: title) ?? 0
    }

    func didSelectedCounty(by index: Int) {
        interactor.didSelectCountry(countries[index])
    }
}

// MARK: - AddTobaccoLineOutputModule implementation
extension AddManufacturerPresenter: AddTobaccoLineOutputModule {
    func send(_ tobaccoLine: TobaccoLine?) {
        if let tobaccoLine {
            interactor.receivedTobaccoLine(tobaccoLine, for: editingTobaccoLineIndex)
        }
        editingTobaccoLineIndex = nil
    }
}

// MARK: - AddCountryOutputModule implementation
extension AddManufacturerPresenter: AddCountryOutputModule {
    func send(_ countries: [Country]) {
        interactor.receivedCountriesAfterUpdate(countries)
    }
}

private extension String {
    static let dash = "-"
}

//
//
//  AddTobaccoViewController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import UIKit
import SnapKit

protocol AddTobaccoViewInputProtocol: AnyObject {
    func clearView()
    func setupContent(_ viewModel: AddTobaccoEntity.ViewModel)
    func setupTastes()
    func setupSelectedManufacturer(_ index: Int)
    func setupSelectedTobaccoLine(_ index: Int)
    func setupMainImage(_ image: Data?, textButton: String)
    func showLoading()
    func hideLoading()
}

enum AddPicketType {
    case manufacturer
    case tobaccoLine
}

protocol AddTobaccoViewOutputProtocol: AnyObject {
    func pressedButtonAdded(with data: AddTobaccoEntity.EnteredData)
    func didSelected(by index: Int, type: AddPicketType)
    func didSelectMainImage(with imageURL: URL)
    func numbreOfRows(type: AddPicketType) -> Int
    func receiveRow(by index: Int, type: AddPicketType) -> String
    func receiveIndexRow(for title: String, type: AddPicketType) -> Int
    func viewDidLoad()
    var tasteNumberOfRows: Int { get }
    func getTasteViewModel(by index: Int) -> TasteCollectionCellViewModel
    func didTouchSelectedTastes()
}

final class AddTobaccoViewController: HTScrollContentViewController {
    // MARK: - Public properties
    var presenter: AddTobaccoViewOutputProtocol!

    override var contentViewHeight: CGFloat {
        topSpacingFromSuperview +
        nameView.heightView +
        manufacturerPickerView.viewHeight +
        tasteCollectionView.contentSize.height +
        tasteButton.frame.height +
        descriptionView.heightView +
        tobaccoLinePickerView.viewHeight +
        view.frame.width * imageHeightRelativeToWidth +
        spacingBetweenViews * (6 +
                               (tasteButton.isHidden ? 0 : 1)
        )
    }

    // MARK: - UI properties
    private let nameView = AddTextFieldView()
    private let manufacturerPickerView = AddPickerView()
    private let tasteCollectionView = TasteCollectionView()
    private let tasteButton = UIButton.createAppBigButton("Добавить вкусы")
    private let descriptionView = AddTextView()
    private let tobaccoLinePickerView = AddPickerView()
    private let imagePickerView = ImageButtonPickerView()
    private let addedButton = UIButton.createAppBigButton()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        overrideUserInterfaceStyle = .light

        setupSubviews()
        presenter.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addedButton.createCornerRadius()
        tasteButton.createCornerRadius()
    }

    override func hideViewTapped() {
        super.hideViewTapped()
        manufacturerPickerView.hideView()
        tobaccoLinePickerView.hideView()
    }

    // MARK: - Setups
    override func setupSubviews() {
        super.setupSubviews()

        contentScrollView.addSubview(nameView)
        nameView.setupView(textLabel: "Название",
                           placeholder: "Введите название производителя...",
                           delegate: self)
        nameView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topSpacingFromSuperview)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
            make.height.equalTo(nameView.heightView)
        }

        contentScrollView.addSubview(manufacturerPickerView)
        manufacturerPickerView.setupView(text: "Выбрать производителя табака")
        manufacturerPickerView.delegate = self
        manufacturerPickerView.snp.makeConstraints { make in
            make.top.equalTo(nameView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }

        contentScrollView.addSubview(tasteCollectionView)
        tasteCollectionView.tasteDelegate = self
        tasteCollectionView.snp.makeConstraints { make in
            make.top.equalTo(manufacturerPickerView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }
        let tapTasteCollection = UITapGestureRecognizer(target: self, action: #selector(touchForSelectTastes))
        tasteCollectionView.addGestureRecognizer(tapTasteCollection)

        contentScrollView.addSubview(tasteButton)
        tasteButton.snp.makeConstraints { make in
            make.top.equalTo(tasteCollectionView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
            make.height.equalTo(40)
        }
        tasteButton.addTarget(self, action: #selector(touchForSelectTastes), for: .touchUpInside)

        contentScrollView.addSubview(descriptionView)
        descriptionView.setupView(textLabel: "Описание табака (не обязательно)")
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(tasteButton.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }

        contentScrollView.addSubview(tobaccoLinePickerView)
        tobaccoLinePickerView.setupView(text: "Выбрать линейку табака")
        tobaccoLinePickerView.delegate = self
        tobaccoLinePickerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionView.snp.bottom).offset(spacingBetweenViews)
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
        }

        view.addSubview(addedButton)
        addedButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(sideSpacingConstraint)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(spacingBetweenViews)
            make.height.equalTo(50)
        }
        addedButton.addTarget(self, action: #selector(touchAddedButton), for: .touchUpInside)

        contentScrollView.addSubview(imagePickerView)
        imagePickerView.snp.makeConstraints { make in
            make.top.equalTo(tobaccoLinePickerView.snp.bottom).inset(-spacingBetweenViews)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(spacingBetweenViews)
            make.width.equalTo(imagePickerView.snp.height)
        }
        imagePickerView.delegate = self

        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        activityIndicator.hidesWhenStopped = true

        setupConstrainsScrollView(top: view.safeAreaLayoutGuide,
                                  bottom: addedButton.snp.top,
                                  bottomConstant: -spacingBetweenViews)
        }

    // MARK: - Private methods
    private func changeManufacturerPickerView(by row: Int) {
        manufacturerPickerView.text = presenter.receiveRow(by: row, type: .manufacturer)
    }

    private func changeTobaccoLinePickerView(by row: Int) {
        tobaccoLinePickerView.text = presenter.receiveRow(by: row, type: .tobaccoLine)
    }

    // MARK: - Selectors
    @objc
    private func touchAddedButton() {
        let data = AddTobaccoEntity.EnteredData(
                        name: nameView.text,
                        description: descriptionView.text)
        presenter.pressedButtonAdded(with: data)
    }

    @objc
    private func touchForSelectTastes() {
        presenter.didTouchSelectedTastes()
    }
}

// MARK: - ViewInputProtocol implementation
extension AddTobaccoViewController: AddTobaccoViewInputProtocol {
    func clearView() {
        nameView.text = ""
        descriptionView.text = ""
        changeManufacturerPickerView(by: 0)
        changeTobaccoLinePickerView(by: 0)
        nameView.becomeFirstResponderTextField()
        imagePickerView.image = nil
        tasteCollectionView.reloadData()
    }

    func setupContent(_ viewModel: AddTobaccoEntity.ViewModel) {
        nameView.text = viewModel.name
        descriptionView.text = viewModel.description
        addedButton.setTitle(viewModel.textButton, for: .normal)
    }

    func setupTastes() {
        tasteCollectionView.reloadData()
        let isEmpty = presenter.tasteNumberOfRows == 0
        tasteButton.isHidden = !isEmpty
        tasteButton.snp.updateConstraints { $0.height.equalTo(isEmpty ? 40 : 0)}
    }

    func setupSelectedManufacturer(_ index: Int) {
        changeManufacturerPickerView(by: index)
    }

    func setupSelectedTobaccoLine(_ index: Int) {
        changeTobaccoLinePickerView(by: index)
    }

    func setupMainImage(_ image: Data?, textButton: String) {
//        imagePickerView.textButton = textButton
        if let image = image {
            imagePickerView.image = UIImage(data: image)
        }
    }

    func showLoading() {
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
    }
}

// MARK: - UITextFieldDelegate implementation
extension AddTobaccoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameView.isMyTextField(textField) {
            return descriptionView.becomeFirstResponder()
        }
        return false
    }
}

// MARK: - ImagePickerViewDelegate implementation
extension AddTobaccoViewController: ImagePickerViewDelegate {
    func present(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }

    func didSelectedImage(by fileURL: URL) {
        presenter.didSelectMainImage(with: fileURL)
    }

    func didCancel() {

    }
}

// MARK: - AddPickerViewDelegate implementation
extension AddTobaccoViewController: AddPickerViewDelegate {
    func receiveNumberOfRows(_ pickerView: AddPickerView) -> Int {
        if pickerView === manufacturerPickerView {
            return presenter.numbreOfRows(type: .manufacturer)
        } else if pickerView === tobaccoLinePickerView {
            return presenter.numbreOfRows(type: .tobaccoLine)
        }
        return 0
    }

    func receiveRow(_ pickerView: AddPickerView, by row: Int) -> String {
        if pickerView === manufacturerPickerView {
            return presenter.receiveRow(by: row, type: .manufacturer)
        } else if pickerView === tobaccoLinePickerView {
            return presenter.receiveRow(by: row, type: .tobaccoLine)
        }
        return ""
    }

    func didSelected(_ pickerView: AddPickerView, by row: Int) {
        if pickerView === manufacturerPickerView {
            presenter.didSelected(by: row, type: .manufacturer)
        } else if pickerView === tobaccoLinePickerView {
            presenter.didSelected(by: row, type: .tobaccoLine)
        }
    }

    func receiveIndex(_ pickerView: AddPickerView, for title: String) -> Int {
        if pickerView === manufacturerPickerView {
            return presenter.receiveIndexRow(for: title, type: .manufacturer)
        } else if pickerView === tobaccoLinePickerView {
            return presenter.receiveIndexRow(for: title, type: .tobaccoLine)
        }
        return -1
    }
}

// MARK: - TasteCollectionViewDelegate implementation
extension AddTobaccoViewController: TasteCollectionViewDelegate {
    func getItem(at index: Int) -> TasteCollectionCellViewModel {
        presenter.getTasteViewModel(by: index)
    }

    var numberOfRows: Int {
        presenter.tasteNumberOfRows
    }

    func didSelectTaste(at index: Int) {

    }
}

extension AddTobaccoViewController {
    var imageHeightRelativeToWidth: CGFloat { 0.5 }
}

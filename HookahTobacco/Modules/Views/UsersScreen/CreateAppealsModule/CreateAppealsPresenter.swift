//
//
//  CreateAppealsPresenter.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 17.09.2023.
//
//

import Foundation
import IVCollectionKit
import UIKit
import AVFoundation

class CreateAppealsPresenter {
    // MARK: - Public properties
    weak var view: CreateAppealsViewInputProtocol!
    var interactor: CreateAppealsInteractorInputProtocol!
    var router: CreateAppealsRouterProtocol!

    // MARK: - Private properties
    private var themes: [ThemeAppeal] = []
    private var contents: [URL] = []
    private var selectContentIndex: Int?
    private var contentDirector: CustomCollectionDirector?

    // MARK: - Private methods
    private func setupContentView() {
        guard let contentDirector else { return }
        contentDirector.removeAll()

        var rows: [AbstractCollectionItem] = []

        for (index, content) in contents.enumerated() {
            let item = ContentCreateAppealsCollectionCellItem(index: index,
                                                              image: receivePreviewImage(url: content)
            ) { [weak self] index in
                self?.contents.remove(at: index)
                self?.setupContentView()
            }
            let row = CollectionItem<ContentCreateAppealsCollectionViewCell>(item: item)
            rows.append(row)
        }

        if contents.count < Constant.maxCountContent {
            let addItem = AddContentCreateAppealsCollectionCellItem { [weak self] in
                self?.router.showAlertSheet(title: nil, message: nil, actions: [
                    AlertSheetAction(title: R.string.localizable.generalCancel(), style: .cancel, action: {}),
                    AlertSheetAction(title: R.string.localizable.createAppealsAlertSheetCameraTitle(),
                                     style: .default,
                                     action: {
                        self?.view.showImagePickerView(.camera)
                    }),
                    AlertSheetAction(title: R.string.localizable.createAppealsAlertSheetGalleryTitle(),
                                     style: .default,
                                     action: {
                        self?.view.showImagePickerView(.picker)
                    })
                ])
            }
            let addRow = CollectionItem<AddContentCreateAppealsCollectionViewCell>(item: addItem)
            rows.append(addRow)
        }

        let section = CollectionSection(items: rows)

        contentDirector += section
        contentDirector.reload()
    }

    private func receivePreviewImage(url: URL) -> UIImage? {
        if let imageData = try? Data(contentsOf: url),
           let image = UIImage(data: imageData) {
            return image
        }
        let asset = AVURLAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        if let cgImage = try? generator.copyCGImage(at: CMTime(seconds: 2, preferredTimescale: 60), actualTime: nil) {
            return UIImage(cgImage: cgImage)
        } else {
            return nil
        }
    }
}

// MARK: - InteractorOutputProtocol implementation
extension CreateAppealsPresenter: CreateAppealsInteractorOutputProtocol {
    func receivedStartingData(_ themes: [ThemeAppeal], _ user: ThemeAppealUser?) {
        view.hideLoading()
        self.themes = themes
        view.setupView(CreateAppealsEntity.ViewModel(name: user?.name ?? "",
                                                     email: user?.email ?? ""))
        view.setupThemeView(.notSelectThemeText)
        setupContentView()
    }

    func receivedSuccessNewAppeal(_ response: CreateAppealResponse) {
        view.hideLoading()
        router.popView(response)
    }

    func receivedError(_ error: HTError) {
        view.hideLoading()
        if case .apiError(let apiErrors) = error {
            for apiError in apiErrors {
                if apiError.fieldName == CreateAppealEntity.CodingKeys.name.rawValue {
                    view.showError(apiError.message, field: .name)
                } else if apiError.fieldName == CreateAppealEntity.CodingKeys.email.rawValue {
                    view.showError(apiError.message, field: .email)
                } else if apiError.fieldName == CreateAppealEntity.CodingKeys.theme.rawValue {
                    view.showError(apiError.message, field: .theme)
                } else if apiError.fieldName == CreateAppealEntity.CodingKeys.message.rawValue {
                    view.showError(apiError.message, field: .message)
                } else {
                    router.showError(with: apiError.message)
                }
            }
        } else {
            router.showError(with: error.message)
        }
    }
}

// MARK: - ViewOutputProtocol implementation
extension CreateAppealsPresenter: CreateAppealsViewOutputProtocol {
    func viewDidLoad() {
        let collectionView = view.getContentCollectionView()
        collectionView.didSelect = { [weak self] indexPath in
            guard let self else { return }
            if indexPath.row != self.contents.count {
                self.selectContentIndex = indexPath.row
                self.view.showImagePickerView(.picker)
            }
        }
        contentDirector = CustomCollectionDirector(collectionView: collectionView)
        view.showBlockLoading()
        interactor.receiveStaringData()
    }

    func pressedThemeView() {
        let selectedTheme = interactor.receiveSelectTheme()
        let index = themes.firstIndex(where: { $0.id == selectedTheme?.id })
        let items = themes.map { $0.name }
        router.showSelectTheme(title: R.string.localizable.createAppealsSelectThemeBottomSheetTitle(),
                               items: items,
                               selectedIndex: index,
                               output: self)
    }

    func selectContent(_ content: CreateAppealsEntity.Content) {
        let sizeInMb = Double(content.size) / 1024.0 / 1024.0
        switch content.type {
        case .photo:
            if sizeInMb >= Constant.maxSizeImage {
                router.showError(
                    with: R.string.localizable.createAppealsMaxSizeImageMessage("\(Int(Constant.maxSizeImage))"))
                return
            }
        case .video:
            if sizeInMb >= Constant.maxSizeVideo {
                router.showError(
                    with: R.string.localizable.createAppealsMaxSizeVideoMessage("\(Int(Constant.maxSizeVideo))"))
                return
            }
        }
        if let selectContentIndex {
            contents[selectContentIndex] = content.url
        } else {
            contents.append(content.url)
        }
        setupContentView()
    }

    func cancelSelectContent() {
        selectContentIndex = nil
    }

    func pressedSendButton(_ enterData: CreateAppealsEntity.EnterData) {
        var hasError = false
        if enterData.name.isEmpty {
            view.showError(R.string.localizable.createAppealsTextFieldEmptyErrorMessage(), field: .name)
            hasError = true
        }
        if enterData.email.isEmpty {
            view.showError(R.string.localizable.createAppealsTextFieldEmptyErrorMessage(), field: .email)
            hasError = true
        } else if !enterData.email.isEmailValid() {
            view.showError(R.string.localizable.createAppealsEmailNotValidMessage(), field: .email)
            hasError = true
        }
        if enterData.message.isEmpty {
            view.showError(R.string.localizable.createAppealsTextFieldEmptyErrorMessage(), field: .message)
            hasError = true
        }
        if interactor.receiveSelectTheme() == nil {
            view.showError(R.string.localizable.createAppealsTextFieldEmptyErrorMessage(), field: .theme)
            hasError = true
        }

        if hasError {
            return
        }

        view.showBlockLoading()
        interactor.sendAppeal(enterData, contents: contents)
    }
}

// MARK: - SelectListBottomSheetOutputModule implementation
extension CreateAppealsPresenter: SelectListBottomSheetOutputModule {
    func receiveNewData(_ newIndex: Int?) {
        if let newIndex {
            let oldTheme = interactor.receiveSelectTheme()
            interactor.updateSelectedTheme(newIndex)
            let theme = themes[newIndex]
            view.setupThemeView(theme.name)
            if oldTheme?.id != theme.id {
                view.setupContentView(isShow: theme.isContent)
                contents = []
                setupContentView()
            }
        } else {
            view.setupThemeView(.notSelectThemeText)
        }
    }
}

private extension String {
    static let notSelectThemeText = R.string.localizable.createAppealsThemeSelect()
}

private struct Constant {
    static let maxCountContent = 10
    static let maxSizeVideo = 30.0 // в мб
    static let maxSizeImage = 15.0 // в мб
}

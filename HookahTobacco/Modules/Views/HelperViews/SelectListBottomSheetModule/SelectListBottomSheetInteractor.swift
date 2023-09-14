//
//
//  SelectListBottomSheetInteractor.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 14.09.2023.
//
//

import Foundation

protocol SelectListBottomSheetInteractorInputProtocol: AnyObject {
    func receiveStartingData()
}

protocol SelectListBottomSheetInteractorOutputProtocol: AnyObject {
    func receivedStartingData(title: String?, items: [String], selectedIndex: Int?)
}

class SelectListBottomSheetInteractor {
    // MARK: - Public properties
    weak var presenter: SelectListBottomSheetInteractorOutputProtocol!

    // MARK: - Dependency

    // MARK: - Private properties
    private let title: String?
    private let items: [String]
    private let selectedItemIndex: Int?

    // MARK: - Initializers
    init(title: String?, items: [String], selectedItemIndex: Int?) {
        self.title = title
        self.items = items
        self.selectedItemIndex = selectedItemIndex
    }

    // MARK: - Private methods

}
// MARK: - InputProtocol implementation 
extension SelectListBottomSheetInteractor: SelectListBottomSheetInteractorInputProtocol {
    func receiveStartingData() {
        presenter.receivedStartingData(title: title, items: items, selectedIndex: selectedItemIndex)
    }
}

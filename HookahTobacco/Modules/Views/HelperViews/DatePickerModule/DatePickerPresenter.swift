//
//
//  DatePickerPresenter.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 15.08.2023.
//
//

import Foundation

class DatePickerPresenter {
    // MARK: - Public properties
    weak var view: DatePickerViewInputProtocol!
    var interactor: DatePickerInteractorInputProtocol!
    var router: DatePickerRouterProtocol!

    // MARK: - Private properties
    private var dateValue: Date!

    // MARK: - Private methods

}

// MARK: - InteractorOutputProtocol implementation
extension DatePickerPresenter: DatePickerInteractorOutputProtocol {
    func receivedStartingData(dateValue: Date?, title: String?, minDate: Date?, maxDate: Date?) {
        self.dateValue = dateValue ?? Date()
        view.setupView(valueData: self.dateValue, title: title, minDate: minDate, maxDate: maxDate)
    }
}

// MARK: - ViewOutputProtocol implementation
extension DatePickerPresenter: DatePickerViewOutputProtocol {
    func viewDidLoad() {
        interactor.receiveStartingData()
    }

    func changedDateOnPicker(_ newDate: Date) {
        dateValue = newDate
    }

    func pressedChooseButton() {
        router.dismissView(dateValue)
    }
}

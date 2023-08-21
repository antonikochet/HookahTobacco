//
//
//  DatePickerInteractor.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 15.08.2023.
//
//

import Foundation

protocol DatePickerInteractorInputProtocol: AnyObject {
    func receiveStartingData()
}

protocol DatePickerInteractorOutputProtocol: AnyObject {
    func receivedStartingData(dateValue: Date?, title: String?, minDate: Date?, maxDate: Date?)
}

class DatePickerInteractor {
    // MARK: - Public properties
    weak var presenter: DatePickerInteractorOutputProtocol!

    // MARK: - Dependency

    // MARK: - Private properties
    private var dateValue: Date?
    private let title: String?
    private let minDate: Date?
    private let maxDate: Date?

    // MARK: - Initializers
    init(dateValue: Date?, title: String?, minDate: Date?, maxDate: Date?) {
        self.dateValue = dateValue
        self.title = title
        self.minDate = minDate
        self.maxDate = maxDate
    }

    // MARK: - Private methods

}
// MARK: - InputProtocol implementation 
extension DatePickerInteractor: DatePickerInteractorInputProtocol {
    func receiveStartingData() {
        presenter.receivedStartingData(dateValue: dateValue, title: title, minDate: minDate, maxDate: maxDate)
    }
}

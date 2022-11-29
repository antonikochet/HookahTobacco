//
//  DataManagerSubscriberProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 26.11.2022.
//

import Foundation

enum NewStateType<T> {
    case update(T)
    case error(Error)
}

protocol DataManagerSubscriberProtocol: AnyObject {
    func notify<T>(for type: T.Type, newState: NewStateType<[T]>)
}

struct WeakSubject {
    weak var value: DataManagerSubscriberProtocol?
    init(_ value: DataManagerSubscriberProtocol) { self.value = value }
}

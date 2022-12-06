//
//  ObserverProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 26.11.2022.
//

import Foundation

protocol ObserverProtocol {
    func subscribe<T>(to type: T.Type, subscriber: SubscriberProtocol)
    func unsubscribe<T>(to type: T.Type, subscriber: SubscriberProtocol)
}

protocol SubscriberProtocol: AnyObject { }

struct WeakSubject {
    weak var value: SubscriberProtocol?
    init(_ value: SubscriberProtocol) { self.value = value }
}

//
//  UpdateDataSubscriberProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 26.11.2022.
//

import Foundation

enum UpdateDataNotification<T> {
    case update(T)
    case error(Error)
}

protocol UpdateDataSubscriberProtocol: SubscriberProtocol {
    func notify<T>(for type: T.Type, notification: UpdateDataNotification<[T]>)
}

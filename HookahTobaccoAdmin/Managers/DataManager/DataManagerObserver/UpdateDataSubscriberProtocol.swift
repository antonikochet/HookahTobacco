//
//  UpdateDataSubscriberProtocol.swift
//  HookahTobaccoAdmin
//
//  Created by антон кочетков on 26.11.2022.
//

import Foundation
import HookahTobaccoCore

enum UpdateDataNotification<T> {
    case update(T)
    case error(DomainError)
}

protocol UpdateDataSubscriberProtocol: SubscriberProtocol {
    func notify<T>(for type: T.Type, notification: UpdateDataNotification<[T]>)
}

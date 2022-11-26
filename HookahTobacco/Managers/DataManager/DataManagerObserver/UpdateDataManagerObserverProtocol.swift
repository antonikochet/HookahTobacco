//
//  UpdateDataManagerObserverProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 26.11.2022.
//

import Foundation

protocol UpdateDataManagerObserverProtocol {
    func subscribe<T>(to type: T.Type, subscriber: DataManagerSubscriberProtocol)
    func unsubscribe<T>(to type: T.Type, subscriber: DataManagerSubscriberProtocol)
}

//
//  SystemSubscriberProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 04.12.2022.
//

import Foundation

struct SystemNotificationType {}

enum SystemNotification {
    case successMessage(String, Double)
    case errorMessage(String, Double)
}

protocol SystemSubscriberProtocol: SubscriberProtocol {
    func notify(_ notification: SystemNotification)
}

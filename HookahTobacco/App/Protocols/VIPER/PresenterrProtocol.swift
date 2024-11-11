//
//  PresenterrProtocol.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 20.08.2023.
//

import Foundation
import HookahTobaccoCore

protocol PresenterrProtocol: AnyObject {
    func receivedError(_ error: DomainError)
}

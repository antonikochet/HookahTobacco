//
//  PresenterrProtocol.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 20.08.2023.
//

import Foundation

protocol PresenterrProtocol: AnyObject {
    func receivedError(_ error: HTError)
}

//
//  ViewProtocol.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 07.08.2023.
//

import Foundation

protocol ViewProtocol: AnyObject {
    func showLoading()
    func showBlockLoading()
    func hideLoading()
}

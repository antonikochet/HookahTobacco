//
//  NetworkingServiceProtocols.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 20.08.2023.
//

import Foundation
import HookahTobaccoCore

protocol GetDataNetworkingServiceProtocol {
    func receiveImage(for url: String, completion: ResultBlock<Data>?)
}

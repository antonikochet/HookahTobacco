//
//  SendingMetricErrorMock.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 07.11.2024.
//

import HookahTobaccoCore

final class SendingMetricErrorMock: SendingMetricErrorProtocol {
    func send(_ error: Error) {
        #if DEBUG
        print("‼️‼️‼️", error.localizedDescription, "‼️‼️‼️", separator: "\n")
        #endif
    }
}

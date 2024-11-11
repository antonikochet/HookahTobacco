//
//  SendingMetricErrorProtocol.swift
//
//
//  Created by Антон Кочетков on 07.11.2024.
//

public protocol SendingMetricErrorProtocol {
    func send(_ error: Error)
}

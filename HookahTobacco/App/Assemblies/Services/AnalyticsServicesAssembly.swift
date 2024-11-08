//
//  AnalyticsServicesAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.02.2023.
//

import Foundation
import Swinject
import Moya
import HookahTobaccoCore
import HookahTobaccoNetwork

final class AnalyticsServicesAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SendingMetricErrorProtocol.self) { _ in
            SendingMetricErrorMock()
        }
    }
}

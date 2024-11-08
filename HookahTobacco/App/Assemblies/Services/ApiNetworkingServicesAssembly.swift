//
//  ApiNetworkingServicesAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.02.2023.
//

import Foundation
import Swinject
import Moya
import HookahTobaccoCore
import HookahTobaccoNetwork

class ApiNetworkingServicesAssembly: Assembly {
    func assemble(container: Container) {
        // TODO: - перенести в отдельный Assembly
        container.register(SendingMetricErrorProtocol.self) { _ in
            SendingMetricErrorMock()
        }
    }
}

//
//  CreateTaskProtocol.swift
//
//
//  Created by Антон Кочетков on 06.11.2024.
//

import Moya

protocol CreateTaskProtocol {
    func createRequest() -> Moya.Task
}

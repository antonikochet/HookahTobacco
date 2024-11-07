//
//  DefaultTarget.swift
//
//
//  Created by Anton Kochetkov on 04.07.2023.
//

import Moya
import Foundation

public protocol DefaultTarget: TargetType {

}

extension DefaultTarget {
    public var baseURL: URL {
        Api.baseURL
    }

    public var headers: [String: String]? {
        return nil
    }
}

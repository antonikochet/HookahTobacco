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
    var baseURL: URL {
        Api.baseURL
    }

    var headers: [String: String]? {
        return nil
    }
}

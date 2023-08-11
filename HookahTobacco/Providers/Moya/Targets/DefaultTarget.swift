//
//  DefaultTarget.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 04.07.2023.
//

import Moya
import Foundation

protocol DefaultTarget: TargetType {

}

extension DefaultTarget {
    var baseURL: URL {
        Api.baseURL
    }

    var headers: [String: String]? {
        return nil
    }
}

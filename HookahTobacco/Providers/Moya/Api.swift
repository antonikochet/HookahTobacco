//
//  Api.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 04.07.2023.
//

import Foundation
import Moya

struct Api {

}

extension Api {
    static var baseURL: URL {
        guard let url = try? GlobalConstant.apiURL.asURL() else {
            fatalError("not valid baseURL")
        }
        return url
    }
}

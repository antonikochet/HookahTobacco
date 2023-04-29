//
//  Country+Extension.swift
//  HookahTobacco
//
//  Created by антон кочетков on 30.04.2023.
//

import Foundation

extension Country: DataNetworkingServiceProtocol {
    init?(_ data: [String : Any], uid: String) {
        self.name = ""
    }
    
    func formatterToData() -> [String : Any] {
        [:]
    }
    
    
}

extension Country: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = try container.decode(String.self, forKey: .uid)
        name = try container.decode(String.self, forKey: .name)
    }
    
    enum CodingKeys: String, CodingKey {
        case uid = "id"
        case name
    }
}

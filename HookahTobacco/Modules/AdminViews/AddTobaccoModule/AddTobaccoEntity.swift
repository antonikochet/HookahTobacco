//
//
//  AddTobaccoEntity.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import Foundation

struct AddTobaccoEntity {
    struct EnteredData {
        let name: String?
        let description: String?
    }
    
    struct Tobacco {
        let name: String
        let description: String
    }
    
    struct ViewModel {
        let name: String
        let description: String
        let textButton: String
    }
}

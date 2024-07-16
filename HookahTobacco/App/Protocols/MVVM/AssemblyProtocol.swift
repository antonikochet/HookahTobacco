//
//  AssemblyProtocol.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 16.07.2024.
//

import Foundation
import Swinject
import UIKit

protocol AssemblyProtocol {
    func assemble(resolver: Resolver) -> UIViewController
}

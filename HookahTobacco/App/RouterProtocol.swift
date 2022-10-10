//
//  RouterProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 10.10.2022.
//

import UIKit

protocol RouterProtocol: AnyObject {
    init(_ appAssembler: AppAssemblerProtocol, _ viewController: UIViewController)
}

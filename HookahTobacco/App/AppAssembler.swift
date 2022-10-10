//
//  AppAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 10.10.2022.
//

import Foundation
import Swinject

protocol AppAssemblerProtocol {
    var resolver: Resolver { get }
    func receiveModule(_ module: ModuleProtocol.Type, _ data: DataModuleProtocol?) -> ModuleProtocol?
}

class AppAssembler: AppAssemblerProtocol {
    private var assembler: Assembler
    private var registerModule: [String: (DataModuleProtocol?) -> ModuleProtocol]
    
    init() {
        assembler = Assembler()
        registerModule = [:]
    }
    
    func apply(assemblies: [Assembly]) {
        assembler.apply(assemblies: assemblies)
    }
    
    func registerModule(_ assembly: Assembly,
                        _ nameModule: String,
                        _ createModuleClosure: @escaping (DataModuleProtocol?) -> ModuleProtocol) {
        assembler.apply(assembly: assembly)
        registerModule.updateValue(createModuleClosure, forKey: nameModule)
    }
    
    //MARK: AppAssemblerProtocol
    var resolver: Resolver {
        return assembler.resolver
    }
    
    func receiveModule(_ module: ModuleProtocol.Type, _ data: DataModuleProtocol? = nil) -> ModuleProtocol? {
        if let constructor = registerModule[module.nameModule] {
            return constructor(data)
        } else {
            print("Модуль \(module.nameModule) не был найден в зарегистрированных модулях.")
            return nil
        }
    }
}

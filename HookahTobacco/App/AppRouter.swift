//
//  AppAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 10.10.2022.
//

import UIKit
import Swinject

protocol AppRouterProtocol {
    var resolver: Resolver { get }
    
    func pushViewController(module: ModuleProtocol.Type, moduleData data: DataModuleProtocol?, animateDisplay: Bool)
    func pushViewController(module: ModuleProtocol.Type, moduleData data: DataModuleProtocol?, animateDisplay: Bool, completion:(() -> Void)?)
    func popViewConroller(animated: Bool, completion:(() -> Void)?)
    
    func presentView(module: ModuleProtocol.Type, moduleData data: DataModuleProtocol?, animated: Bool)
    func dismissView(animated: Bool, completion:(() -> Void)?)
    
    func presentViewModally(module: ModuleProtocol.Type, moduleData data: DataModuleProtocol?)
}

class AppRouter: AppRouterProtocol {
    private var assembler: Assembler
    private var registerModule: [String: (DataModuleProtocol?) -> ModuleProtocol]
    var navigationController: UINavigationController!
    
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
    
    private func receiveModule(_ module: ModuleProtocol.Type, _ data: DataModuleProtocol? = nil) -> ModuleProtocol? {
        if let constructor = registerModule[module.nameModule] {
            return constructor(data)
        } else {
            print("Модуль \(module.nameModule) не был найден в зарегистрированных модулях.")
            return nil
        }
    }
    
    //MARK: AppRouterProtocol
    var resolver: Resolver {
        assembler.resolver
    }
    
    func pushViewController(module: ModuleProtocol.Type, moduleData data: DataModuleProtocol? = nil, animateDisplay: Bool) {
        pushViewController(module: module, moduleData: data, animateDisplay: animateDisplay, completion: nil)
    }
    
    func pushViewController(module: ModuleProtocol.Type, moduleData data: DataModuleProtocol? = nil, animateDisplay: Bool, completion: (() -> Void)?) {
        guard let module = receiveModule(module, data),
              let view = module.createModule(self) else { return }
        navigationController.pushViewController(view, animated: animateDisplay)
        completion?()
    }
    
    func popViewConroller(animated: Bool, completion:(() -> Void)? = nil) {
        navigationController.popViewController(animated: animated)
        completion?()
    }
    
    func presentView(module: ModuleProtocol.Type, moduleData data: DataModuleProtocol? = nil, animated: Bool) {
        guard let module = receiveModule(module, data),
              let view = module.createModule(self) else { return }
        navigationController.setViewControllers([view], animated: animated)
    }
    
    func dismissView(animated: Bool, completion: (() -> Void)? = nil) {
        //TODO: реализовать метод AppRouterProtocol.dismissView
        fatalError("Закрытие окна не реализовано. реализовать метод dismissView")
    }
    
    func presentViewModally(module: ModuleProtocol.Type, moduleData data: DataModuleProtocol? = nil) {
//        guard let module = receiveModule(module, data),
//              let view = module.createModule(self) else { return }
        //TODO: реализовать метод AppRouterProtocol.presentViewModally
        fatalError("Открытие модального окна не реализовано. реализовать метод presentViewModally")
    }
    
    
}
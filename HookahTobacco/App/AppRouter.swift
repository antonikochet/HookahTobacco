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

    func restartViewApp()
    func pushViewController(module: ModuleProtocol.Type,
                            moduleData data: DataModuleProtocol?,
                            animateDisplay: Bool)
    func pushViewController(module: ModuleProtocol.Type,
                            moduleData data: DataModuleProtocol?,
                            animateDisplay: Bool,
                            completion: CompletionBlock?)
    func popViewConroller(animated: Bool, completion: CompletionBlock?)

    func presentView(module: ModuleProtocol.Type, moduleData data: DataModuleProtocol?, animated: Bool)
    func dismissView(animated: Bool, completion: CompletionBlock?)

    func presentViewModally(module: ModuleProtocol.Type, moduleData data: DataModuleProtocol?)

    func presentAlert(type: AlertFactory.AlertType, completion: CompletionBlock?)
}

class AppRouter: AppRouterProtocol {
    private var assembler: Assembler
    private var registerModule: [String: (DataModuleProtocol?) -> ModuleProtocol]
    var appWindow: UIWindow

    init(_ window: UIWindow) {
        assembler = Assembler()
        registerModule = [:]
        self.appWindow = window
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

    func startAppPresent(_ containers: [(module: ModuleProtocol.Type,
                                         tabBarItem: TabBarItemProtocol)]) {
        var createdContainers: [(module: ModuleProtocol,
                                 tabBarItem: TabBarItemProtocol)] = []
        containers.forEach {
            if let module = receiveModule($0.module) {
                createdContainers.append((module, $0.tabBarItem))
            }
        }

        let dependency = HTTabBarControllerDependency(appRouter: self,
                                                      containers: createdContainers)
        let tabBar = resolver.resolve(HTTabBarController.self,
                                      argument: dependency)
        appWindow.rootViewController = tabBar
    }

    private func receiveContainer() -> HTNavigationController? {
        guard let tabBar = appWindow.rootViewController as? HTTabBarController,
              let navController = tabBar.selectedViewController as? HTNavigationController
        else { return nil }
        return navController
    }

    private func receiveModule(_ module: ModuleProtocol.Type,
                               _ data: DataModuleProtocol? = nil) -> ModuleProtocol? {
        if let constructor = registerModule[module.nameModule] {
            return constructor(data)
        } else {
            print("Модуль \(module.nameModule) не был найден в зарегистрированных модулях.")
            return nil
        }
    }

    private func topViewController(controller: UIViewController?) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }

    // MARK: - AppRouterProtocol
    var resolver: Resolver {
        assembler.resolver
    }

    func restartViewApp() {
        assembleContainers()
    }

    func pushViewController(module: ModuleProtocol.Type,
                            moduleData data: DataModuleProtocol? = nil,
                            animateDisplay: Bool) {
        pushViewController(module: module,
                           moduleData: data,
                           animateDisplay: animateDisplay,
                           completion: nil)
    }

    func pushViewController(module: ModuleProtocol.Type,
                            moduleData data: DataModuleProtocol? = nil,
                            animateDisplay: Bool,
                            completion: CompletionBlock?) {
        guard let module = receiveModule(module, data),
              let view = module.createModule(self),
              let navigationController = receiveContainer() else { return }
        navigationController.pushViewController(view, animated: animateDisplay)
        completion?()
    }

    func popViewConroller(animated: Bool,
                          completion: CompletionBlock? = nil) {
        guard let navigationController = receiveContainer() else { return }
        navigationController.popViewController(animated: animated)
        completion?()
    }

    func presentView(module: ModuleProtocol.Type,
                     moduleData data: DataModuleProtocol? = nil,
                     animated: Bool) {
        guard let module = receiveModule(module, data),
              let view = module.createModule(self),
              let navigationController = receiveContainer() else { return }
        navigationController.setViewControllers([view], animated: animated)
    }

    func dismissView(animated: Bool, completion: CompletionBlock? = nil) {
        guard let navigationController = topViewController(controller: appWindow.rootViewController) else { return }
        navigationController.dismiss(animated: true)
        completion?()
    }

    func presentViewModally(module: ModuleProtocol.Type, moduleData data: DataModuleProtocol? = nil) {
        guard let module = receiveModule(module, data),
              let view = module.createModule(self) as? BottomSheetPresenter,
              let navigationController = topViewController(controller: appWindow.rootViewController) else { return }
        view.present(from: navigationController, swipeToDismissListenerClosure: nil)
    }

    func presentAlert(type: AlertFactory.AlertType, completion: CompletionBlock?) {
        guard let viewController = topViewController(controller: appWindow.rootViewController) else { return }
        AlertFactory.shared.showAlert(type, from: viewController, completion: completion)
    }
}

extension AppRouter: SystemSubscriberProtocol {
    func notify(_ notification: SystemNotification) {
        guard let viewController = topViewController(controller: appWindow.rootViewController) else { return }
        switch notification {
        case .successMessage(let message, let delay):
            AlertFactory.shared.showAlert(.toastSuccess(message: message,
                                                        delay: delay,
                                                        position: .top),
                                          from: viewController)
        case .errorMessage(let message, let delay):
            AlertFactory.shared.showAlert(.toastError(message: message,
                                                      delay: delay,
                                                      position: .top),
                                          from: viewController)
        }
    }
}

//
//  HTNavigationController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 30.10.2022.
//

import UIKit

class HTNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup navigationBar
        
    }
    
    func setupTabBarItem(with title: String,
                         image: UIImage?,
                         selectedImage: UIImage?) {
        self.tabBarItem = UITabBarItem(title: title,
                                       image: image?.withRenderingMode(.alwaysTemplate),
                                       selectedImage: selectedImage?.withRenderingMode(.alwaysTemplate))
    }
}

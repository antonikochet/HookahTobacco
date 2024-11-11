//
//  extension+UILabel.swift
//
//
//  Created by Anton Kochetkov on 08.09.2023.
//

import UIKit
import HookahTobaccoResources

extension UILabel {
    public func setForTitleName() {
        textColor = ResourceManager.provider.color(forKey: .primaryTitle).colorUIKit
        font = UIFont.appFont(size: 18.0, weight: .medium)
        numberOfLines = 0
    }
}

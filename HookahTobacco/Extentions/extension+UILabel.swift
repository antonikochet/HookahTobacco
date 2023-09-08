//
//  extension+UILabel.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 08.09.2023.
//

import UIKit

extension UILabel {
    func setForTitleName() {
        textColor = R.color.primaryTitle()
        font = UIFont.appFont(size: 18.0, weight: .regular)
        numberOfLines = 0
    }
}

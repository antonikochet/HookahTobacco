//
//  extension+UIVisualEffectView.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 07.08.2023.
//

import UIKit

extension UIVisualEffectView {

    private var filterLayer: CALayer? {
        return layer.sublayers?.first
    }

    private var effectSubviewLayer: CALayer? {
        return layer.sublayers?.last
    }

    private var blurFilter: NSObject? {
        return filterLayer?
            .filters?.compactMap({ $0 as? NSObject })
            .first(where: { $0.value(forKey: "name") as? String == "gaussianBlur" })
    }

    var effectBackgroundColor: UIColor? {
        get {
            if let background = effectSubviewLayer?.backgroundColor {
                return UIColor(cgColor: background)
            } else {
                return nil
            }
        }
        set {
            effectSubviewLayer?.backgroundColor = newValue?.cgColor
        }
    }

    var blurRadius: CGFloat {
        get {
            return blurFilter?.value(forKey: "inputRadius") as? CGFloat ?? 0
        }
        set {
            blurFilter?.setValue(newValue, forKey: "inputRadius")
        }
    }
}

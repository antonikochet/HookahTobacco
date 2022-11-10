//
//  extention + UIViewController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 19.09.2022.
//

import UIKit
import SnapKit

extension UIViewController {
    func showAlertError(title: String?, message: String?, completion: (()->())? = nil) {
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alertVC.addAction(okAction)
        
        self.present(alertVC, animated: true)
    }
    

    func showSuccessView(duration: Double, delay: Double) {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        view.alpha = 0.0
        view.layer.cornerRadius = 16
        self.view.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 75, height: 75))
            make.centerX.centerY.equalTo(self.view)
        }
        
        let imageView = UIImageView(image: UIImage(systemName: "checkmark"))
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(view).inset(10)
        }
        
        UIView.animate(withDuration: TimeInterval(duration), delay: 0) {
            view.alpha = 0.8
        } completion: { completion in
            if completion {
                UIView.animate(withDuration: TimeInterval(duration),
                               delay: TimeInterval(delay),
                               options: []) {
                    view.alpha = 0
                } completion: { compl in
                    if compl {
                        view.removeFromSuperview()
                    }
                }
            }
        }
    }
}

extension UIViewController {
    var sideSpacingConstraint: CGFloat { 32 }
    var spacingBetweenViews: CGFloat { 16 }
    var topSpacingFromSuperview: CGFloat { 32 }
}

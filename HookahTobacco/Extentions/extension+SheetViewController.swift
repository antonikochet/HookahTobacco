//
//  extension+SheetViewController.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 07.08.2023.
//

import UIKit
import FittedSheets

extension SheetViewController {

    private struct Keys {
        static var didSwipedToDismiss: UInt8 = 0
    }

    var didSwipedToDismiss: CompletionBlock? {
        get {
          return objc_getAssociatedObject(self, &Keys.didSwipedToDismiss) as? CompletionBlock
        }
        set {
          if let newValue {
            objc_setAssociatedObject(
                self,
                &Keys.didSwipedToDismiss,
                newValue as CompletionBlock?,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
          }
        }
      }

    func addSwipeToDismissListener(callback: @escaping CompletionBlock) {
        guard let gestureRecognizers = view.gestureRecognizers?
            .first(where: { $0.description.contains("InitialTouchPanGestureRecognizer") }) as? UIPanGestureRecognizer
        else { return }

        gestureRecognizers.addTarget(self, action: #selector(_handlePan(_:)))
        didSwipedToDismiss = callback
    }

    @objc private func _handlePan(_ gesture: UIPanGestureRecognizer) {

        let offset: CGFloat = contentViewController.view.transform.ty

        switch gesture.state {
        case .ended:
            let velocity = (0.2 * gesture.velocity(in: self.view).y)
            var finalHeight = contentViewController.view.frame.height - offset - velocity
            if velocity > 500 {
                // They swiped hard, always just close the sheet when they do
                finalHeight = -1
            }

            guard !(finalHeight > 0 || !dismissOnPull) else { return }
            didSwipedToDismiss?()
        default:
            break
        }
    }
}

//
//  BottomSheetPresenter.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 07.08.2023.
//

import UIKit
import FittedSheets

protocol BottomSheetPresenter where Self: UIViewController {
    var sizes: [SheetSize] { get }
    var isShowGrip: Bool { get }
    var handledScrollView: UIScrollView? { get }
    var dismissOnOverlayTap: Bool { get }
    var dismissOnPull: Bool { get }

    func present(from viewController: UIViewController,
                 swipeToDismissListenerClosure: CompletionBlock?
    )
}

// MARK: - Defaults settings
extension BottomSheetPresenter {
    var sizes: [SheetSize] {
        [.intrinsic]
    }

    var isShowGrip: Bool {
        true
    }

    var handledScrollView: UIScrollView? {
        nil
    }

    var dismissOnOverlayTap: Bool {
        true
    }

    var dismissOnPull: Bool {
        true
    }
}

extension BottomSheetPresenter {
    func present(from viewController: UIViewController,
                 swipeToDismissListenerClosure: CompletionBlock?
    ) {
        let options = SheetOptions(
            pullBarHeight: isShowGrip ? LayoutValues.BottomSheet.pullBarHeightWithGrip
                                      : LayoutValues.BottomSheet.pullBarHeightWithoutGrip,
            shouldExtendBackground: true,
            shrinkPresentingViewController: false
        )

        let sheetController = SheetViewController(
            controller: self,
            sizes: sizes,
            options: options
        )

        if let swipeToDismissListenerClosure {
            sheetController.addSwipeToDismissListener(callback: swipeToDismissListenerClosure)
        }

        sheetController.cornerRadius = LayoutValues.BottomSheet.cornerRadius
        sheetController.gripSize = isShowGrip ? LayoutValues.GripView.size : LayoutValues.GripView.zeroSize
        sheetController.gripColor = Colors.BottomSheet.gripColor
        sheetController.overlayColor = Colors.BottomSheet.overlayColor
        sheetController.dismissOnOverlayTap = dismissOnOverlayTap
        sheetController.dismissOnPull = dismissOnPull
        sheetController.allowPullingPastMaxHeight = false
        
        if let handledScrollView {
            sheetController.handleScrollView(handledScrollView)
        }

        viewController.present(sheetController, animated: true, completion: nil)
    }
}

private struct LayoutValues {
    struct BottomSheet {
        static let pullBarHeightWithGrip: CGFloat = 32.0
        static let pullBarHeightWithoutGrip: CGFloat = 14.0
        static let cornerRadius: CGFloat = 24.0
    }
    struct GripView {
        static let zeroSize: CGSize = .zero
        static let size: CGSize = CGSize(width: 64.0, height: 4.0)
    }
}
private struct Colors {
    struct BottomSheet {
        static let overlayColor = UIColor.black.withAlphaComponent(0.5)
        static let gripColor = UIColor.systemGray4
    }
}

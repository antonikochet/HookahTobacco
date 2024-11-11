//
//  ViewDidLoadModifier.swift
//
//
//  Created by Антон Кочетков on 08.07.2024.
//

import SwiftUI

public struct ViewDidLoadModifier: ViewModifier {
    @State private var viewDidLoad = false
    let action: VoidBlock?
    
    public init(action: VoidBlock?) {
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                if viewDidLoad == false {
                    viewDidLoad = true
                    action?()
                }
            }
    }
}

extension View {
    public func onViewDidLoad(perform action: VoidBlock? = nil) -> some View {
        modifier(ViewDidLoadModifier(action: action))
    }
}

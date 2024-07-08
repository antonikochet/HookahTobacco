//
//  ViewDidLoadModifier.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 08.07.2024.
//

import SwiftUI

struct ViewDidLoadModifier: ViewModifier {
    @State private var viewDidLoad = false
    let action: CompletionBlock?
    
    func body(content: Content) -> some View {
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
    func onViewDidLoad(perform action: CompletionBlock? = nil) -> some View {
        modifier(ViewDidLoadModifier(action: action))
    }
}

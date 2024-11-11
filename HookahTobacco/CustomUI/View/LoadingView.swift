//
//  LoadingView.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 07.08.2023.
//

import UIKit
import SwiftUI
import HookahTobaccoUIKitCore

// TODO: - переименовать
struct SLoadingView: UIViewRepresentable {
    @Binding var isLoading: Bool
    
    func makeUIView(context content: Context) -> LoadingView {
        let view = LoadingView(isBlur: true)
        return view
    }
    
    func updateUIView(_ loadingView: LoadingView, context: Context) {
        if isLoading {
            loadingView.startLoading()
            loadingView.isHidden = false
        } else {
            loadingView.stopLoading()
            loadingView.isHidden = true
        }
    }
}


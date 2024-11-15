//
//  LoadingView.swift
//
//
//  Created by Антон Кочетков on 15.11.2024.
//

import SwiftUI
import HookahTobaccoResources

public struct LoadingView: View {
    
    private let isBlur: Bool
    private let cornerRadius: CGFloat
    private let progressViewColor: Color
    
    public init(
        isBlur: Bool,
        cornerRadius: CGFloat = 16.0,
        progressViewColor: Color = ResourceManager.provider.color(forKey: .primaryWhite).colorSwiftUI
    ) {
        self.isBlur = isBlur
        self.cornerRadius = cornerRadius
        self.progressViewColor = progressViewColor
    }
    
    public var body: some View {
        ZStack {
            ProgressView()
                .scaleEffect(1.5)
                .tint(progressViewColor)
        }
        .frame(width: 80, height: 80)
        .background(ResourceManager.provider.color(forKey: .secondarySubtitle).colorSwiftUI
            .blur(radius: isBlur ? 2.0 : 0.0))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

#if DEBUG
#Preview {
    ZStack {
        Color.red
        LoadingView(isBlur: true)
    }
}
#endif

//
//  ApplyButton.swift
//
//
//  Created by Антон Кочетков on 14.11.2024.
//

import SwiftUI
import HookahTobaccoResources

public struct ApplyButton: View {
    private let style: Style
    private let text: String
    private let image: Image?
    @State private var isEnabled: Bool
    private let action: VoidBlock
    
    public init(
        style: Style,
        text: String,
        image: Image?,
        isEnabled: Bool = true,
        action: @escaping VoidBlock
    ) {
        self.style = style
        self.text = text
        self.image = image
        self.isEnabled = isEnabled
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            if let image {
                image
            }
            Text(text)
                .font(Font.appFont(size: 20, weight: .semibold))
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .foregroundStyle(style.foreground)
        .background(isEnabled ? style.background : Constants.disableBackground)
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
        .disabled(!isEnabled)
    }
}

extension ApplyButton {
    public enum Style {
        case primary
        case secondary
    }
}

extension ApplyButton.Style {
    var background: Color {
        switch self {
        case .primary:
            ResourceManager.provider.color(forKey: .primaryPurple).colorSwiftUI
        case .secondary:
            ResourceManager.provider.color(forKey: .secondaryPurple).colorSwiftUI
        }
    }
    
    var foreground: Color {
        switch self {
        case .primary:
            ResourceManager.provider.color(forKey: .primaryWhite).colorSwiftUI
        case .secondary:
            ResourceManager.provider.color(forKey: .primaryWhite).colorSwiftUI
        }
    }
}

private struct Constants {
    static let disableBackground = ResourceManager.provider.color(forKey: .fourthBackground).colorSwiftUI
}

#if DEBUG
#Preview(body: {
    ApplyButton(style: .primary, text: "Button", image: nil) { }
    .padding()
})
#endif

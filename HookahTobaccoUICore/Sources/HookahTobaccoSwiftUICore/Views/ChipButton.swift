//
//  ChipButton.swift
//
//
//  Created by Антон Кочетков on 14.11.2024.
//

import SwiftUI
import HookahTobaccoResources

public struct ChipButton: View {
    
    private let style: Style
    private let text: String
    private let image: Image?
    @State private var isEnabled: Bool = true
    private let action: VoidBlock
    
    public init(
        style: Style,
        text: String,
        image: Image? = nil,
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
        Button(action: action, label: {
            if let image {
                image
            }
            Text(text)
                .font(.appFont(size: 17.0, weight: .semibold))
                .multilineTextAlignment(.center)
        })
        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
        .background((isEnabled ? style.background : Constants.disableBackground).clipShape(RoundedRectangle(cornerRadius: 8.0)))
        .foregroundStyle(style.foreground)
        .overlay(content: {
            style.border 
        })
        .disabled(!isEnabled)
    }
}

extension ChipButton {
    public enum Style {
        case primary
        case secondary
        case third
        case stroke
        case fill
    }
}

extension ChipButton.Style {
    var background: Color {
        switch self {
        case .primary, .secondary, .third, .stroke:
            return .clear
        case .fill:
            return ResourceManager.provider.color(forKey: .primaryPurple).colorSwiftUI
        }
    }

    var foreground: Color {
        switch self {
        case .primary, .stroke:
            return ResourceManager.provider.color(forKey: .primarySubtitle).colorSwiftUI
        case .secondary:
            return ResourceManager.provider.color(forKey: .secondarySubtitle).colorSwiftUI
        case .third:
            return ResourceManager.provider.color(forKey: .primaryPurple).colorSwiftUI
        case .fill:
            return ResourceManager.provider.color(forKey: .primaryWhite).colorSwiftUI
        }
    }

    @ViewBuilder var border: some View {
        switch self {
        case .stroke:
            RoundedRectangle(cornerRadius: 8)
                .stroke(ResourceManager.provider.color(forKey: .primaryPurple).colorSwiftUI, lineWidth: 2.0)
        default:
            EmptyView()
        }
    }
}

private struct Constants {
    static let disableBackground = ResourceManager.provider.color(forKey: .fourthBackground).colorSwiftUI
}

#if DEBUG
#Preview {
    ChipButton(style: .stroke, text: "Button", image: Image(systemName: "plus"), isEnabled: false) {}
}
#endif

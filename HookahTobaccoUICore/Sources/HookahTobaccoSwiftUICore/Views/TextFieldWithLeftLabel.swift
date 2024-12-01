//
//  TextFieldWithLeftLabel.swift
//
//
//  Created by Антон Кочетков on 15.11.2024.
//

import SwiftUI
import HookahTobaccoResources

public struct TextFieldWithLeftLabel: View {
    private let title: String
    private let placeholder: String
    private let type: TextFieldType
    private let rounding: Rounding
    private let canEdit: Bool
    private let didBeginEditing: VoidBlock?
    
    @FocusState private var isFocus: Bool
    @Binding private var text: String
    @Binding private var error: String
    
    public init(
        title: String,
        placeholder: String = "",
        type: TextFieldType,
        rounding: Rounding,
        canEdit: Bool = true,
        text: Binding<String>,
        error: Binding<String>,
        didBeginEditing: VoidBlock? = nil
    ) {
        self.title = title
        self.placeholder = placeholder
        self.type = type
        self.rounding = rounding
        self.canEdit = canEdit
        self._text = text
        self._error = error
        self.didBeginEditing = didBeginEditing
    }
    
    public var body: some View {
        VStack {
            textFieldView
            if !error.isEmpty {
                errorView
            }
        }
        .onTapGesture {
            isFocus = true
        }
    }
    
    private var titleView: some View {
        Text(title)
            .font(.appFont(size: 16.0, weight: .medium))
            .foregroundStyle(ResourceManager.provider.color(forKey: .secondarySubtitle).colorSwiftUI)
    }
    
    @ViewBuilder private var textField: some View {
        switch type {
        case .text, .email:
            TextField(placeholder, text: $text)
        case .password:
            SecureField(placeholder, text: $text)
        }
    }
    
    private var textFieldView: some View {
        HStack {
            if !isFocus {
                titleView
            }
            textField
                .focused($isFocus)
                .multilineTextAlignment(isFocus ? .leading : .trailing)
                .font(.appFont(size: 16.0, weight: .medium))
                .autocorrectionDisabled()
                .autocorrectionDisabled()
                .keyboardType(type.keyboardType)
                .foregroundStyle((error.isEmpty ?
                                  ResourceManager.provider.color(forKey: .primaryBlack) :
                                  ResourceManager.provider.color(forKey: .primaryRed)).colorSwiftUI)
                .tint(ResourceManager.provider.color(forKey: .primaryBlack).colorSwiftUI)
                .onChange(of: isFocus) { isFocused in
                    guard isFocused else { return }
                    if !canEdit {
                        self.isFocus = false
                    }
                    didBeginEditing?()
                    error = ""
                }
                
        }
        .padding(12)
        .background(ResourceManager.provider.color(forKey: .inputBackground).colorSwiftUI)
        .clipShape(RoundedCorner(radius: 19.0, corners: rounding.corners))
    }
    
    @ViewBuilder private var errorView: some View {
        HStack {
            Text(error)
                .foregroundStyle(ResourceManager.provider.color(forKey: .primaryRed).colorSwiftUI)
                .font(.appFont(size: 14.0, weight: .medium))
            Spacer()
        }
        .padding(.horizontal, 8)
    }
}

extension TextFieldWithLeftLabel {
    public enum TextFieldType {
        case text
        case email
        case password

        fileprivate var keyboardType: UIKeyboardType {
            switch self {
            case .text, .password: return .default
            case .email: return .emailAddress
            }
        }
    }
}

extension TextFieldWithLeftLabel {
    public enum Rounding {
        case up
        case down

        fileprivate var corners: UIRectCorner {
            switch self {
            case .down:
                return [.bottomRight]
            case .up:
                return [.topRight]
            }
        }
    }
}

#if DEBUG
#Preview {
    TextFieldWithLeftLabel(
        title: "Title",
        placeholder: "Placeholder",
        type: .text,
        rounding: .up,
        text: .constant("text"),
        error: .constant(""))
        .padding()
}
#endif

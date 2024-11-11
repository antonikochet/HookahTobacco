//
//  DescriptionStackView.swift
//  
//
//  Created by Антон Кочетков on 11.11.2024.
//

import SwiftUI
import HookahTobaccoResources

public struct DescriptionStackViewItem {
    public let name: String
    public let description: String
    
    public init(name: String, description: String) {
        self.name = name
        self.description = description
    }
}

public struct DescriptionStackView: View {
    
    let viewModel: DescriptionStackViewItem
    
    public init(viewModel: DescriptionStackViewItem) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        HStack {
            Text(viewModel.name)
                .font(.appFont(size: 16.0, weight: .regular))
                .foregroundStyle(ResourceManager.provider.color(forKey: .primaryTitle).colorSwiftUI)
            Spacer()
            Text(viewModel.description)
                .font(.appFont(size: 16.0, weight: .light))
                .foregroundStyle(ResourceManager.provider.color(forKey: .primarySubtitle).colorSwiftUI)
        }
    }
}

#if DEBUG
#Preview {
    DescriptionStackView(viewModel: DescriptionStackViewItem(
        name: "Тип",
        description: "Табак"
    ))
    .padding()
}
#endif

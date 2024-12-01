//
//  HTToggleStyle.swift
//  HookahTobaccoUICore
//
//  Created by Антон Кочетков on 19.11.2024.
//

import SwiftUI
import HookahTobaccoResources

public struct HTToggleStyle: ToggleStyle {
    
    public init() {
        
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(ResourceManager.provider.color(forKey: .fourthBackground).colorSwiftUI)
                    .frame(width: 50, height: 30)
                
                Circle()
                    .fill(ResourceManager.provider.color(forKey: .primaryPurple).colorSwiftUI)
                    .frame(width: 24, height: 24)
                    .offset(x: configuration.isOn ? 10 : -10)
                    .animation(.easeInOut, value: configuration.isOn)
            }
            .onTapGesture {
                configuration.isOn.toggle() // Переключение состояния
            }
        }
        .padding()
    }
}

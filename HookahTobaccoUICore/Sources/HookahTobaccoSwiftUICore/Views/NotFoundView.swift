//
//  NotFoundView.swift
//  
//
//  Created by антон кочетков on 01.11.2022.
//

import SwiftUI
import HookahTobaccoResources

public struct NotFoundView: View {
    
    let title: String
    let subtitle: String
    
    public init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }
    
    public var body: some View {
        VStack(spacing: 10) {
            ResourceManager.provider.image(forKey: .notFound).imageSwiftUI
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            Text(title)
                .font(.appFont(size: 26, weight: .bold))
            
            Text(subtitle)
                .font(.appFont(size: 18, weight: .regular))
        }
        .foregroundStyle(ResourceManager.provider.color(forKey: .primaryTitle).colorSwiftUI)
        .multilineTextAlignment(.center)
    }
}

#if DEBUG
#Preview {
    NotFoundView(title: "Title", subtitle: "SubTitle SubTitle SubTitle SubTitle")
}
#endif

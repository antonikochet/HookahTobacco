//
//  NotFoundView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 01.11.2022.
//

import SwiftUI

struct NotFoundView: View {
    
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 10) {
            R.image.notFound.image
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            Text(title)
                .font(.appFont(size: 26, weight: .bold))
            
            Text(subtitle)
                .font(.appFont(size: 18, weight: .regular))
        }
        .foregroundStyle(R.color.primaryTitle.color)
        .multilineTextAlignment(.center)
    }
}

#Preview {
    NotFoundView(title: "Title", subtitle: "SubTitle SubTitle SubTitle SubTitle")
}

//
//  HTImage.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 05.07.2024.
//

import SwiftUI
import HookahTobaccoCore

struct HTImage: View {
    
    let imageURL: String
    let height: CGFloat?
    
    init(imageURL: String, height: CGFloat? = nil) {
        self.imageURL = imageURL
        self.height = height
    }
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
            switch phase {
            case .empty:
                ZStack {
                    Color.gray // TODO: - поменять цвет по фигме
                    ProgressView()
                }
                .frame(height: height)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure:
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(Color.gray) // TODO: - переделать цвет
                    .frame(height: height)
            @unknown default:
                EmptyView()
            }
        }
    }
}

#Preview {
    HTImage(imageURL: Tobacco.mock().imageURL)
        .padding()
}

//
//  HTImage.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 05.07.2024.
//

import SwiftUI

struct HTImage: View {
    
    let imageURL: String
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
            switch phase {
            case .empty:
                ZStack {
                    Color.gray // TODO: - поменять цвет по фигме
                    ProgressView()
                }
                .frame(height: 200)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure:
                RoundedRectangle(cornerRadius: 24)
                    .foregroundStyle(Color.gray) // TODO: - переделать цвет
                    .frame(height: 200)
            @unknown default:
                EmptyView()
            }
        }
    }
}

#Preview {
    HTImage(imageURL: Tobacco.mock.imageURL)
        .padding()
}

//
//  DetailTobaccoView.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 04.07.2024.
//

import SwiftUI

struct DetailTobaccoView<ViewModel: DetailTobaccoViewModelOb>: View {
    
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack {
                image
                
                Text(viewModel.name)
                    .font(.appFont(size: 30, weight: .bold))
                   
                Text("Вкусы: \(viewModel.tastes.joined(separator: ", "))") // TODO: - передать
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)
                
                ForEach(viewModel.info, id: \.name) { viewModel in
                    DescriptionStackViewUI(viewModel: viewModel)
                        .padding(.vertical, 4)
                }
                
                Text(viewModel.description)
                    .font(.appFont(size: 16, weight: .regular))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(viewModel.nameManufacturer)
                    .font(.appFont(size: 28, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.top, 8)
            }
        }
        .padding()
    }
    
    var image: some View {
        AsyncImage(url: viewModel.imageURL) { phase in
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
    NavigationView {
        DetailTobaccoView(viewModel: DetailTobaccoViewModelImpl(
            tobacco: Tobacco.mock
        ))
    }
}

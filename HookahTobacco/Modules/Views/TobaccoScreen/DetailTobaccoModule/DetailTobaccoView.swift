//
//  DetailTobaccoView.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 04.07.2024.
//

import SwiftUI

struct DetailTobaccoView<ViewModel: DetailTobaccoViewModelOb>: View {
    // MARK: - Private properties
    @ObservedObject private var viewModel: ViewModel
    
    // MARK: - Initializers
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack {
                HTImage(imageURL: viewModel.imageURL)
                
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
    
    // MARK: - Subviews
    
    // MARK: - Private methods
    
}

#Preview {
    NavigationView {
        DetailTobaccoView(viewModel: DetailTobaccoViewModelImpl(
            tobacco: Tobacco.mock
        ))
    }
}

//
//  DetailTobaccoView.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 04.07.2024.
//

import SwiftUI
import HookahTobaccoCore
import HookahTobaccoSwiftUICore

struct DetailTobaccoView<ViewModel: DetailTobaccoViewModel>: View {
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
                HTImage(imageURL: viewModel.imageURL, height: 300)
                
                Text(viewModel.name)
                    .font(.appFont(size: 30, weight: .bold))
                
                ChipsContainerView(data: viewModel.tastes.map { ChipModel(title: $0) }) {
                    Text($0.title)
                        .foregroundStyle(R.color.primaryWhite.color)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .fill(R.color.primaryPurple.color))
                }
                
                ForEach(viewModel.info, id: \.name) { viewModel in
                    DescriptionStackView(viewModel: viewModel)
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
            .padding()
        }
    }
    
    // MARK: - Subviews
    
    // MARK: - Private methods
    
}

#Preview {
    NavigationView {
        DetailTobaccoView(viewModel: DetailTobaccoViewModelImpl(
            tobacco: Tobacco.mock()
        ))
    }
}

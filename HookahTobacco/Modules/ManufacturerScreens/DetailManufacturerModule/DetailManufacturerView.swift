//
//
//  DetailManufacturerView.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 17.07.2024.
//
//

import SwiftUI

struct DetailManufacturerView<ViewModel: DetailManufacturerViewModel>: View {
    // MARK: - Private properties
    @ObservedObject private var viewModel: ViewModel
    
    // MARK: - Initializers
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        BaseView(viewModel: viewModel) {
            List {
                infoViewCell
                
                
            }
            .listStyle(.plain)
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Subviews
    private var infoViewCell: some View {
        Section {
            HTImage(imageURL: viewModel.imageURL, height: 300)
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 24, trailing: 16))
            
            infoView
        }
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
    }
    
    private var infoView: some View {
        VStack(alignment: .leading) {
            Text(viewModel.country)
                .font(.appFont(size: 18, weight: .medium))
                .lineLimit(2)
            
            Text("Описание:")
                .font(.appFont(size: 16, weight: .medium))
                .padding(.top, 10)
            
            Text(viewModel.description)
                .font(.appFont(size: 16, weight: .regular))
        }
        .foregroundStyle(R.color.primaryTitle.color)
    }
    
    // MARK: - Private methods
    
}

#if DEBUG
#Preview {
    NavigationView {
        DetailManufacturerView(viewModel: DetailManufacturerViewModelMock())
    }
}
#endif

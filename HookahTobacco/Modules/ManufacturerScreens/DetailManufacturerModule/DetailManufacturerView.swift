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
            ScrollView {
                LazyVStack(alignment: .leading) {
                    HTImage(imageURL: viewModel.imageURL, height: 300)
                        .padding(EdgeInsets(top: 16, leading: 32, bottom: 24, trailing: 32))
                    
                    infoView
                        .padding(.horizontal, 16)
                    
                    tobaccoSections
                        .frame(maxWidth: .infinity)
                    
                    if !viewModel.link.isEmpty {
                        // TODO: - добавить обработку открытия сайта
                        Text("[Cайт](\(viewModel.link))")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.horizontal, 16)
                            .padding(.bottom)
                    }
                }
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Subviews
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
    
    private var tobaccoSections: some View {
        Group {
            if viewModel.tobaccoLines.isEmpty {
                NotFoundView(
                    title: R.string.localizable.manufacteurerDetailEmptyTitle(),
                    subtitle: R.string.localizable.manufacteurerDetailEmptyMessage()
                )
                .padding()
            } else {
                ForEach(viewModel.tobaccoLines) { viewModel in
                    DetailManufacturerTobaccoLineView(
                        title: viewModel.title,
                        description: viewModel.description) {
                            ForEach(viewModel.tobaccos, id: \.id) { viewModel in
                                TobaccoView(viewModel: viewModel)
                                    .onTapGesture {
                                        self.viewModel.showDetail(id: viewModel.id)
                                    }
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                }
            }
        }
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

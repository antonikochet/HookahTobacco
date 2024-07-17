//
//
//  ManufacturerListView.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 16.07.2024.
//
//

import SwiftUI

struct ManufacturerListView<ViewModel: ManufacturerListViewModel>: View {
    // MARK: - Private properties
    @ObservedObject private var viewModel: ViewModel
    
    // MARK: - Initializers
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        BaseView(viewModel: viewModel) {
            list
        }
        .navigationTitle(R.string.localizable.manufacteurerListTitle())
        .navigationBarTitleDisplayMode(.inline)
        .background(R.color.primaryBackground.color)
        .onViewDidLoad(perform: viewModel.startReceiveManufacturers)
    }
    
    // MARK: - Subviews
    private var list: some View {
        List(viewModel.manufacturers, id: \.id) { viewModel in
            ManufacturerCellView(viewModel: viewModel)
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
                .onTapGesture {
                    self.viewModel.showDetail(id: viewModel.id)
                }
        }
        .listStyle(.plain)
    }
    // MARK: - Private methods
    
}
#if DEBUG
#Preview {
    NavigationView {
        ManufacturerListView(viewModel: ManufacturerListViewModelMock())
    }
}
#endif

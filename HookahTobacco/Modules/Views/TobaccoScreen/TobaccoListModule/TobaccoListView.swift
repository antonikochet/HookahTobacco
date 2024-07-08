//
//
//  TobaccoListView.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 07.07.2024.
//
//

import SwiftUI

struct TobaccoListView<ViewModel: TobaccoListViewModel>: View {
    // MARK: - Private properties
    @ObservedObject private var viewModel: ViewModel
    
    // MARK: - Initializers
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        BaseView(viewModel: viewModel) {
            List(viewModel.tobaccos, id: \.id) { viewModel in
                TobaccoView(viewModel: viewModel)
                    .buttonStyle(.plain)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
                    .onTapGesture {
                        self.viewModel.showDetail(id: viewModel.id)
                    }
            }
            .listStyle(.plain)
        }
        .navigationTitle(R.string.localizable.titleNone())
        .background(R.color.primaryBackground.color)
        .onViewDidLoad {
            viewModel.startReceiveTobacco()
        }
    }
    
    // MARK: - Subviews
    
    // MARK: - Private methods
    
}

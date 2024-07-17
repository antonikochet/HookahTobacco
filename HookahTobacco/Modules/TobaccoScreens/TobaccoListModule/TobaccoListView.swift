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
    @FocusState private var keyboardFocus: Bool
    
    // MARK: - Initializers
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: .zero) {
            if viewModel.isShowSearch {
                searchBar
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 4, trailing: 16))
            }
            BaseView(viewModel: viewModel) {
                list
            }
        }
        .navigationTitle(viewModel.title)
        .background(R.color.primaryBackground.color)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                filter
            }
        }
        .onViewDidLoad(perform: viewModel.startReceiveTobacco)
    }
    
    // MARK: - Subviews
    private var searchBar: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 0))
                
                TextField(R.string.localizable.searchBarPlaceholderText(), text: $viewModel.search)
            }
            .foregroundStyle(R.color.secondarySubtitle.color)
            
            Spacer()
            
            if !viewModel.search.isEmpty {
                SwiftUI.Button(R.string.localizable.generalCancel()) {
                    viewModel.search = ""
                    keyboardFocus = false
                }
                .tint(R.color.secondarySubtitle.color)
                .font(.appFont(size: 16, weight: .medium))
                .padding(.horizontal, 10)
            }
            
        }
        .frame(height: 36)
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(R.color.inputBackground.color)
        )
        .focused($keyboardFocus)
    }
    
    private var list: some View {
        List(viewModel.tobaccos.indices, id: \.self) { index in
            let viewModel = viewModel.tobaccos[index]
            TobaccoView(viewModel: viewModel)
                .buttonStyle(.plain)
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
                .onTapGesture {
                    self.viewModel.showDetail(id: viewModel.id)
                }
                .onAppear {
                    if self.viewModel.tobaccos.count - 3 < index {
                        self.viewModel.receiveNextPage()
                    }
                }
                
        }
        .listStyle(.plain)
        .refreshable {
            viewModel.refresh()
        }
    }
    
    private var filter: some View {
        ZStack {
            SwiftUI.Button(action: viewModel.showFilter) {
                R.image.filter.image
            }
            if viewModel.hasFilter {
                Circle()
                    .fill(R.color.primaryPurple.color)
                    .frame(width: 8, height: 8)
                    .offset(x: 12, y: -8)
            }
        }
    }
    // MARK: - Private methods
    
}

//
//  BaseView.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 08.07.2024.
//

import SwiftUI

struct BaseView<ViewModel: BaseViewModel, Content: View>: View {
    
    @ObservedObject private var viewModel: ViewModel
    @ViewBuilder private var content: () -> Content
    
    init(viewModel: ViewModel, @ViewBuilder content: @escaping () -> Content) {
        self.viewModel = viewModel
        self.content = content
    }
    
    var body: some View {
        ZStack {
            content()
            if let viewModel = viewModel.infoView {
                SInfoView(viewModel: viewModel)
            }
            SLoadingView(isLoading: $viewModel.isLoading)
                .frame(width: 80, height: 80)
        }
            .alert(
                viewModel.alertState.title,
                isPresented: $viewModel.hasAlert) {
                    ForEach(viewModel.alertState.actions, id: \.title) { action in
                        SwiftUI.Button(action.title) {
                            action.action?()
                        }
                    }
                } message: {
                    Text(viewModel.alertState.message)
                }
    }
}

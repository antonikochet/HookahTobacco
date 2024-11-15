//
//
//  LoginView.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 15.11.2024.
//
//

import SwiftUI
import HookahTobaccoSwiftUICore

struct LoginView<ViewModel: LoginViewModel>: View {
    // MARK: - Private properties
    @ObservedObject private var viewModel: ViewModel
    
    // MARK: - Initializers
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        BaseView(viewModel: viewModel) {
            VStack {
                titleView
                textFieldsView
                    .padding(.vertical, 24.0)
                buttonsView
                    .padding(.top, 12.0)
                    .padding(.horizontal, 21)
            }
            .padding(.horizontal, 24.0)
        }
    }
    
    // MARK: - Subviews
    private var titleView: some View {
        LazyVStack(alignment: .leading, spacing: 8.0) {
            Text(R.string.localizable.loginTitleText())
                .font(.appFont(size: 30.0, weight: .bold))
            
            Text(R.string.localizable.loginSubtitleText())
                .font(.appFont(size: 14.0, weight: .regular))
                
        }
        .foregroundStyle(R.color.primaryTitle.color)
    }
    
    private var textFieldsView: some View {
        VStack(spacing: 16.0) {
            TextFieldWithLeftLabel(title: R.string.localizable.loginEmailTextFieldTitle(),
                                   type: .email,
                                   rounding: .up,
                                   text: $viewModel.email,
                                   error: $viewModel.emailError)
            
            TextFieldWithLeftLabel(title: R.string.localizable.loginPasswordTextFieldTitle(),
                                   type: .password,
                                   rounding: .down,
                                   text: $viewModel.password,
                                   error: $viewModel.passwordError)
        }
    }
    
    private var buttonsView: some View {
        VStack(spacing: 16.0) {
            ApplyButton(style: .primary,
                        text: R.string.localizable.loginLoginButtonTitle()) {
                viewModel.login()
            }
            ChipButton(style: .third,
                       text: R.string.localizable.loginRegistrationButtonTitle()) {
                viewModel.registration()
            }
        }
    }
    // MARK: - Private methods
    
}

#if DEBUG
#Preview {
    LoginView(viewModel: LoginViewModelMock())
}
#endif

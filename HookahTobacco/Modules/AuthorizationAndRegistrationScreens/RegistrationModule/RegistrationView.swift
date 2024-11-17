//
//
//  RegistrationView.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 17.11.2024.
//
//

import SwiftUI
import HookahTobaccoSwiftUICore

struct RegistrationView<ViewModel: RegistrationViewModel>: View {
    // MARK: - Private properties
    @ObservedObject private var viewModel: ViewModel
    
    // MARK: - Initializers
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        BaseView(viewModel: viewModel) {
            VStack(spacing: 24.0) {
                titleView
                nameTextFields
                passwordTextFields
                continueButton
                    .padding(.top, 12.0)
                    .padding(.horizontal, 21.0)
            }
            .padding(.horizontal, 24.0)
            .dismissKeyboardOnTap()
        }
        .background(R.color.primaryBackground.color)
    }
    
    // MARK: - Subviews
    private var titleView: some View {
        LazyVStack(alignment: .leading, spacing: 4.0) {
            Text(R.string.localizable.registrationTitleLabelText())
                .font(.appFont(size: 30.0, weight: .bold))
            
            Text(R.string.localizable.registrationSubtitleLabelText())
                .font(.appFont(size: 16.0, weight: .regular))
                
        }
        .foregroundStyle(R.color.primaryTitle.color)
    }
    
    private var nameTextFields: some View {
        VStack(spacing: 16.0) {
            TextFieldWithLeftLabel(title: R.string.localizable.registrationUsernameTitle(),
                                   type: .text,
                                   rounding: .up,
                                   text: $viewModel.username,
                                   error: $viewModel.usernameError)
            
            TextFieldWithLeftLabel(title: R.string.localizable.registrationEmailTitle(),
                                   type: .email,
                                   rounding: .down,
                                   text: $viewModel.email,
                                   error: $viewModel.emailError)
        }
    }
    
    private var passwordTextFields: some View {
        VStack(spacing: 16.0) {
            TextFieldWithLeftLabel(title: R.string.localizable.registrationPasswordTitle(),
                                   type: .password,
                                   rounding: .up,
                                   text: $viewModel.password,
                                   error: $viewModel.passwordError)
            
            TextFieldWithLeftLabel(title: R.string.localizable.registrationRepeatPasswordTitle(),
                                   type: .password,
                                   rounding: .down,
                                   text: $viewModel.repeatPassword,
                                   error: $viewModel.repeatPasswordError)
        }
    }

    private var continueButton: some View {
        ApplyButton(style: .primary,
                    text: R.string.localizable.registrationContinueButtonTitle()) {
            viewModel.continueRegistration()
        }
    }
    
    // MARK: - Private methods
}
#if DEBUG
#Preview {
    RegistrationView(viewModel: RegistrationViewModelMock())
}
#endif

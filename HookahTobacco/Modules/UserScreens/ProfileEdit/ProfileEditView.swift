//
//
//  ProfileEditView.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 17.11.2024.
//
//

import SwiftUI
import HookahTobaccoSwiftUICore

struct ProfileEditView<ViewModel: ProfileEditViewModel>: View {
    // MARK: - Private properties
    @ObservedObject private var viewModel: ViewModel
    
    // MARK: - Initializers
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        BaseView(viewModel: viewModel) {
            VStack(spacing: 36) {
                titleView
                VStack(spacing: 24) {
                    nameView
                    if !viewModel.isRegistration {
                        usernameView
                    }
                    dateOfBirthAndSexView
                    agreementView
                        .padding(.horizontal, 8.0)
                }
                continueButton
                    .padding(.horizontal, 21.0)
            }
            .padding(.horizontal, 24.0)
        }
        .background(R.color.primaryBackground.color)
    }
    
    // MARK: - Subviews
    private var titleView: some View {
        LazyVStack(alignment: .leading, spacing: 8.0) {
            Text(viewModel.isRegistration ?
                 R.string.localizable.profileEditTitleLabelTextRegistration() :
                 R.string.localizable.profileEditTitleLabelTextEdit())
                .font(.appFont(size: 30.0, weight: .bold))
                .foregroundStyle(R.color.primaryTitle.color)
        }
    }
    
    private var nameView: some View {
        VStack(spacing: 16.0) {
            TextFieldWithLeftLabel(title: R.string.localizable.profileEditFirstNameTitle(),
                                   type: .text,
                                   rounding: .up,
                                   text: $viewModel.firstName,
                                   error: $viewModel.firstNameError)
            
            TextFieldWithLeftLabel(title: R.string.localizable.profileEditLastNameTitle(),
                                   type: .text,
                                   rounding: .down,
                                   text: $viewModel.lastName,
                                   error: $viewModel.lastNameError)
        }
    }
    
    private var usernameView: some View {
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
    
    private var dateOfBirthAndSexView: some View {
        VStack(spacing: 16.0) {
            TextFieldWithLeftLabel(title: R.string.localizable.profileEditDateOfBirthTitle(),
                                   type: .text,
                                   rounding: .up,
                                   canEdit: false,
                                   text: $viewModel.dateOfBirth,
                                   error: $viewModel.dateOfBirthError) {
                viewModel.showSelectBirthday()
            }
            
            TextFieldWithLeftLabel(title: R.string.localizable.profileEditSexTitle(),
                                   type: .email,
                                   rounding: .down,
                                   canEdit: false,
                                   text: $viewModel.sex,
                                   error: $viewModel.sexError) {
                viewModel.showSelectSex()
            }
        }
    }
    
    private var agreementView: some View {
        HStack {
            Toggle(isOn: $viewModel.agreements) {
                // TODO: - добавить гиперссылки
                Text(R.string.localizable.profileEditAgreementTextViewText())
                    .font(.appFont(size: 16.0, weight: .regular))
                    .foregroundStyle(R.color.primaryTitle.color)
            }
            .toggleStyle(HTToggleStyle())
        }
    }
    
    private var continueButton: some View {
        ApplyButton(style: .primary,
                    text: viewModel.isRegistration ?
                        R.string.localizable.profileEditButtonTitleRegistration() :
                        R.string.localizable.profileEditButtonTitleEdit(),
                    isEnabled: viewModel.agreements) {
            viewModel.pressedContinue()
        }
    }
    
    // MARK: - Private methods
}
#if DEBUG
#Preview {
    ProfileEditView(viewModel: ProfileEditViewModelMock())
}
#endif

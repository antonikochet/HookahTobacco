//
//
//  ProfileEditViewModel.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 17.11.2024.
//
//

import Foundation

protocol ProfileEditViewModel: BaseViewModel, ObservableObject {
    var isRegistration: Bool { get }
    var firstName: String { get set }
    var firstNameError: String { get set }
    var lastName: String { get set }
    var lastNameError: String { get set }
    var username: String { get set }
    var usernameError: String { get set }
    var email: String { get set }
    var emailError: String { get set }
    var dateOfBirth: String { get set }
    var dateOfBirthError: String { get set }
    var sex: String { get set }
    var sexError: String { get set }
    var agreements: Bool { get set }
    
    func showSelectSex()
    func showSelectBirthday()
    func pressedContinue()
}

final class ProfileEditViewModelImpl: BaseViewModelImpl, ProfileEditViewModel {
    // MARK: - ViewModel properties
    private(set) var isRegistration: Bool
    @Published var firstName: String = ""
    @Published var firstNameError: String = ""
    @Published var lastName: String = ""
    @Published var lastNameError: String = ""
    @Published var username: String = ""
    @Published var usernameError: String = ""
    @Published var email: String = ""
    @Published var emailError: String = ""
    @Published var dateOfBirth: String = ""
    @Published var dateOfBirthError: String = ""
    @Published var sex: String = ""
    @Published var sexError: String = ""
    @Published var agreements: Bool = false
    
    // MARK: - Private properties
    
    // MARK: - Dependency
    
    // MARK: - Initializers
    init(isRegistration: Bool) {
        self.isRegistration = isRegistration
    }
    
    // MARK: - ViewModel methods
    func showSelectSex() {
        
    }
    
    func showSelectBirthday() {
        
    }
    
    func pressedContinue() {
        
    }
    
    // MARK: - Private methods
}

#if DEBUG
final class ProfileEditViewModelMock: BaseViewModelImpl, ProfileEditViewModel {
    // MARK: - ViewModel properties
    private(set) var isRegistration: Bool = false
    @Published var firstName: String = ""
    @Published var firstNameError: String = ""
    @Published var lastName: String = ""
    @Published var lastNameError: String = ""
    @Published var username: String = ""
    @Published var usernameError: String = ""
    @Published var email: String = ""
    @Published var emailError: String = ""
    @Published var dateOfBirth: String = ""
    @Published var dateOfBirthError: String = ""
    @Published var sex: String = ""
    @Published var sexError: String = ""
    @Published var agreements: Bool = false
    
    // MARK: - ViewModel methods
    func showSelectSex() {
        
    }
    
    func showSelectBirthday() {
        
    }
    
    func pressedContinue() {
        
    }
}
#endif

//
//  FireBaseAuthService.swift
//  HookahTobacco
//
//  Created by антон кочетков on 17.09.2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct FBUser: UserProtocol {
    var uid: String
    var email: String?
    var firstName: String?
    var lastName: String?
    var isAdmin: Bool
    var isAnonymous: Bool
}

class FirebaseAuthService {
    // TODO: удалить когда уберутся все ссылки на свойство
    static let shared = FirebaseAuthService(handlerErrors: FirebaseAuthHandlerErrors())

    // MARK: - Private properties
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    private var _currectUser: UserProtocol?
    private var handlerErrors: AuthHandlerErrors

    // MARK: - Init
    init(handlerErrors: AuthHandlerErrors) {
        self.handlerErrors = handlerErrors
    }

    // MARK: - Public methods
    func startAuth() {
        guard let user = auth.currentUser else {
            registrationAnonymous()
            return
        }
        receiveUserInfo(user: user)
    }

    // MARK: - Private methods
    private func receiveUserInfo(user: User, completion: AuthServiceCompletion? = nil) {
        db.collection(NamedFireStore.Collections.users)
            .document(user.uid)
            .getDocument { [weak self] snapshot, error in
                guard let self = self else { return }
                guard error == nil else {
                    completion?(self.handlerErrors.handlerError(error!))
                    return
                }
                self._currectUser = FBUser(user: user, data: snapshot?.data())
                completion?(nil)
            }
    }

    private func registrationAnonymous() {
        auth.signInAnonymously { result, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let user = result?.user else {
                print(AuthError.userNotFound.localizedDescription)
                return
            }
            self._currectUser = FBUser(user: user)
        }
    }
}

// MARK: - AuthServiceProtocol implementation
extension FirebaseAuthService: AuthServiceProtocol {
    var isUserLoggerIn: Bool {
        auth.currentUser != nil
    }

    var currectUser: UserProtocol? {
        _currectUser
    }

    func login(with email: String, password: String, completion: AuthServiceCompletion?) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            guard error == nil else {
                completion?(self.handlerErrors.handlerError(error!))
                return
            }
            guard let user = result?.user else { completion?(AuthError.userNotFound); return }
            self.receiveUserInfo(user: user, completion: completion)
        }
    }

    func logout(completion: AuthServiceCompletion?) {
        do {
            try auth.signOut()
            completion?(nil)
        } catch let error {
            completion?(self.handlerErrors.handlerError(error))
        }
    }
}

// MARK: - RegistrationServiceProtocol implementation
extension FirebaseAuthService: RegistrationServiceProtocol {
    func registration(email: String, password: String, completion: RegistrationServiceCompletion?) {
        auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error {
                completion?(self.handlerErrors.handlerError(error))
                return
            }
            if let user = authResult?.user {
                self._currectUser = FBUser(user: user)
                completion?(nil)
            }
        }
    }

    func sendRegistrationUserData(firstName: String, lastName: String, photo: Data?,
                                  completion: RegistrationServiceCompletion?) {
        guard let uid = _currectUser?.uid else { return }
        let data: [String: Any] = [
            NamedFireStore.Documents.User.firstName: firstName,
            NamedFireStore.Documents.User.lastName: lastName
        ]
        db.collection(NamedFireStore.Collections.users)
            .document(uid)
            .setData(data) { [weak self] error in
                guard let self = self else { return }
                if let error {
                    completion?(self.handlerErrors.handlerError(error))
                    return
                }
            completion?(nil)
        }
    }
}

fileprivate extension FBUser {
    init?(user: User, data: [String: Any]? = nil) {
        let isAdmin = data?[NamedFireStore.Documents.User.isAdmin] as? Bool
        let firstName = data?[NamedFireStore.Documents.User.firstName] as? String
        let lastName = data?[NamedFireStore.Documents.User.lastName] as? String

        self.uid = user.uid
        self.email = user.email
        self.firstName = firstName
        self.lastName = lastName
        self.isAdmin = isAdmin ?? true
        self.isAnonymous = user.isAnonymous
    }
}

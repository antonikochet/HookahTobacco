//
//  FireBaseAuthService.swift
//  HookahTobacco
//
//  Created by антон кочетков on 17.09.2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct FBUser {
    let uid: String
    let email: String?
    let firstName: String?
    let lastName: String?
    let isAdmin: Bool
}

class FireBaseAuthService: AuthServiceProtocol {
    typealias User = FBUser
    
    //TODO: возможно убрать одиночку
    static let shared = FireBaseAuthService()
    
    private var auth = Auth.auth()
    private var db = Firestore.firestore()
    private var _currectUser: FBUser?
    
    private init() {
        getUserInfo()
    }
    
    //MARK: public methods and properties
    
    var isUserLoggerIn: Bool {
        auth.currentUser != nil
    }
    
    var currectUser: FBUser? {
        _currectUser
    }
    
    func login(with email: String, password: String, completion: AuthServiceCompletion?) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard error == nil else {
                completion?(error)
                return
            }
            if result?.user != nil {
                self?.getUserInfo()
                completion?(nil)
            } else {
//                completion?(.failure(error)) //TODO: добавить ошибку
            }
        }
    }
    
    func logout(completion: AuthServiceCompletion?) {
        do {
            try auth.signOut()
            completion?(nil)
        } catch let error as NSError {
            completion?(error)
        }
    }
    
    //MARK: private methods and properties
    private func getUserInfo() {
        guard let user = auth.currentUser else {
            self._currectUser = nil
            return
        }
        let docRef = db.collection("users").document(user.uid)
        docRef.getDocument { document, error in
            guard error == nil else {
                print(error!)
                return
            }
            if let document = document, document.exists,
               let data = document.data() {
                self._currectUser = FBUser(uid: user.uid, email: user.email, data: data)
            }
        }
    }
}

//TODO: возможно переделать init FBUser
fileprivate extension FBUser {
    init(uid: String, email: String? = nil, data: [String: Any]? = nil) {
        let isAdmin = data?[NamedFireStore.Documents.User.isAdmin] as? Bool
        let firstName = data?[NamedFireStore.Documents.User.firstName] as? String
        let lastName = data?[NamedFireStore.Documents.User.lastName] as? String
        
        self.uid = uid
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.isAdmin = isAdmin ?? false
    }
}

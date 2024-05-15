//
//  LoginViewModel.swift
//  AuthorizationApp
//
//  Created by Yuliya on 14/05/2024.
//

import Foundation
import FirebaseAuth

final class LoginViewModel {
    @Published
    var errorMessage = String()

    @Published
    var emailLink = String()
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    func checkEmailAvailability(email: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: email) { signInMethods, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            if let signInMethods = signInMethods {
                let isEmailAvailable = signInMethods.isEmpty
                completion(isEmailAvailable, nil)
            } else {
                let unknownError = NSError(domain: "YourDomain", code: 500, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])
                completion(false, unknownError)
            }
        }
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
//    func login(email: String,
//               password: String,
//               completion: @escaping (AuthError?) -> Void) {
//        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
//            if let error = error {
//                var authError: AuthError
//                switch AuthErrorCode(error: error._code) {
//                case .userNotFound, .wrongPassword:
//                    authError = .invalidEmail
//                default:
//                    authError = .unknown
//                }
//                completion(authError)
//            } else {
//                completion(nil)
//            }
//        }
//    }
}

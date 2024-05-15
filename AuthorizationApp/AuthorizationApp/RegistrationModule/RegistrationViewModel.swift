//
//  RegistrationViewModel.swift
//  AuthorizationApp
//
//  Created by Yuliya on 15/05/2024.
//

import Foundation
import FirebaseAuth
import FirebaseDatabaseInternal

final class RegistrationViewModel {
    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion(error)
            } else {
                if let userId = authResult?.user.uid {
                    let userData = ["email": email]
                    let userRef = Database.database().reference().child("users").child(userId)

                    userRef.setValue(userData) { (error, ref) in
                        if let error = error {
                            completion(error)
                        } else {
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
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
}


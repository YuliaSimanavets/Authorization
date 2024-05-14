//
//  AppFlow.swift
//  AuthorizationApp
//
//  Created by Yuliya on 14/05/2024.
//

import UIKit

enum AppFlow {
    static func loginView() -> UIViewController {
        LoginViewController(viewModel: LoginViewModel())
    }

    static func registrationView() -> UIViewController {
        RegistrationViewController()
    }
    
    static func editorView() -> UIViewController {
       EditorViewController(viewModel: EditorViewModel())
    }
}

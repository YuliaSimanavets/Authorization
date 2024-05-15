//
//  LoginViewController.swift
//  AuthorizationApp
//
//  Created by Yuliya on 13/05/2024.
//

import Combine
import UIKit
import SnapKit

class LoginViewController: UIViewController {
    private var viewModel: LoginViewModel
    private var cancellables = [AnyCancellable]()
    
    private let mainTitle = UILabel.new {
        $0.numberOfLines = 0
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 36, weight: .heavy)
        $0.textAlignment = .left
    }
    
    private let fieldsStackView = UIStackView.new {
        $0.distribution = .equalSpacing
        $0.spacing = 5
        $0.axis = .vertical
    }
    
    private let loginTextField = UITextField.new {
        $0.layer.cornerRadius = 25
        $0.backgroundColor = .systemGray6
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .center
        $0.textColor = .black
        $0.tintColor = .systemGray2
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemYellow.cgColor
    }

    private let passwordTextField = UITextField.new {
        $0.layer.cornerRadius = 25
        $0.backgroundColor = .systemGray6
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .center
        $0.textColor = .black
        $0.tintColor = .systemGray2
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemYellow.cgColor
        $0.isSecureTextEntry = true
    }
    
    private let signInButton = UIButton.new {
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 25
        $0.backgroundColor = .systemYellow
    }
    
    private let enterByGoogleButton = UIButton.new {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 25
        $0.backgroundColor = .systemYellow
    }
    
    private let forgotPasswordButton = UIButton.new {
        $0.setTitleColor(.systemGray, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
    }
    
    private let createAccountStackView = UIStackView.new {
        $0.distribution = .equalSpacing
        $0.spacing = 1
        $0.axis = .horizontal
    }
    
    private let registrationTitle = UILabel.new {
        $0.numberOfLines = 0
        $0.textColor = .systemGray
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .right
    }
    
    private let registrationButton = UIButton.new {
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    // MARK: - Lifecycle

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        signInButton.addTarget(self, action: #selector(signInAction), for: .touchUpInside)
        enterByGoogleButton.addTarget(self, action: #selector(enterByGoogleAction), for: .touchUpInside)
        
        registrationButton.addTarget(self, action: #selector(goToCreateAccountAction), for: .touchUpInside)
    }
    
    private func createAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubviews(mainTitle,
                         fieldsStackView,
                         signInButton,
                         enterByGoogleButton,
                         forgotPasswordButton,
                         createAccountStackView)
        fieldsStackView.addArrangedSubviews(loginTextField,
                                            passwordTextField)
        
        createAccountStackView.addArrangedSubviews(registrationTitle,
                                                   registrationButton)
        
        mainTitle.text = "Welcome, \nsign in"
        loginTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        signInButton.setTitle("Sign in", for: .normal)

        enterByGoogleButton.setImage(UIImage(named: "googleLogo"), for: .normal)
        forgotPasswordButton.setTitle("Forgot password?", for: .normal)
        registrationTitle.text = "Don't have an account?"
        registrationButton.setTitle(" Sign up", for: .normal)

        setupConstraints()
    }
    
    private func setupConstraints() {
        mainTitle.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        fieldsStackView.snp.makeConstraints {
            $0.top.equalTo(mainTitle.snp.bottom).inset(-150)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        loginTextField.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        signInButton.snp.makeConstraints {
            $0.top.equalTo(fieldsStackView.snp.bottom).inset(-20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        
        enterByGoogleButton.snp.makeConstraints {
            $0.top.equalTo(signInButton.snp.bottom).inset(-20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(50)
        }
        
        forgotPasswordButton.snp.makeConstraints {
            $0.top.equalTo(enterByGoogleButton.snp.bottom).inset(-70)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        createAccountStackView.snp.makeConstraints {
            $0.top.equalTo(forgotPasswordButton.snp.bottom).inset(-10)
            $0.centerX.equalTo(forgotPasswordButton.snp.centerX)
        }
    }
    
//     MARK: - Actions
    
    @objc
    private func signInAction() {
        guard let email = loginTextField.text,
              viewModel.isValidEmail(email)
        else { return createAlert(with: "Email isn't correct") }
        
        viewModel.checkEmailAvailability(email: email) { [weak self] isAvailable, error in
            guard let self = self else { return }
            if let error = error {
//                self.createAlert(with: error.localizedDescription)
            }
            
            if isAvailable {
                self.createAlert(with: "There is no user with this name. Please, sign up.")
            } else {
                guard let password = passwordTextField.text,
                      viewModel.isValidPassword(password)
                else { return createAlert(with: "Email or password isn't correct") }
                goToEditorScreen()
            }
        }
    }
    
    private func goToEditorScreen() {
        let editorViewController = AppFlow.editorView()
        navigationController?.pushViewController(editorViewController, animated: true)
    }
    
    @objc
    private func enterByGoogleAction() {

    }
    
    @objc
    private func goToCreateAccountAction() {
        let registrationVC = AppFlow.registrationView()
        navigationController?.pushViewController(registrationVC, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let password = (passwordTextField.text ?? "") + string
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTextField.resignFirstResponder()
        return true
    }
}

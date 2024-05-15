//
//  RegistrationViewController.swift
//  AuthorizationApp
//
//  Created by Yuliya on 13/05/2024.
//

import UIKit
import SnapKit

class RegistrationViewController: UIViewController {
    private var viewModel: RegistrationViewModel
    
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
    
    private let joinButton = UIButton.new {
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 25
        $0.backgroundColor = .systemYellow
    }
    
    private let enterByGoogleButton = UIButton.new {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 25
        $0.backgroundColor = .systemYellow
    }
    
    private let signInStackView = UIStackView.new {
        $0.distribution = .equalSpacing
        $0.spacing = 1
        $0.axis = .horizontal
    }
    
    private let signInTitle = UILabel.new {
        $0.numberOfLines = 0
        $0.textColor = .systemGray
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .right
    }
    
    private let signInButton = UIButton.new {
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    // MARK: - Lifecycle

    init(viewModel: RegistrationViewModel) {
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
        
        joinButton.addTarget(self, action: #selector(joinTapped), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(goToSignInAction), for: .touchUpInside)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubviews(mainTitle,
                         fieldsStackView,
                         joinButton,
                         enterByGoogleButton,
                         signInStackView)
        fieldsStackView.addArrangedSubviews(loginTextField,
                                            passwordTextField)
        
        signInStackView.addArrangedSubviews(signInTitle,
                                            signInButton)
        
        mainTitle.text = "Sign up"
        loginTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        joinButton.setTitle("Join", for: .normal)
        
        enterByGoogleButton.setImage(UIImage(named: "googleLogo"), for: .normal)
        signInTitle.text = "Already have an account?"
        signInButton.setTitle(" Sign in", for: .normal)
        
        setupConstraints()
    }
    
    private func createAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okAction)
        present(alert, animated: true)
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
        
        joinButton.snp.makeConstraints {
            $0.top.equalTo(fieldsStackView.snp.bottom).inset(-20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        
        enterByGoogleButton.snp.makeConstraints {
            $0.top.equalTo(joinButton.snp.bottom).inset(-20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(50)
        }
        
        signInStackView.snp.makeConstraints {
            $0.top.equalTo(enterByGoogleButton.snp.bottom).inset(-70)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func goToEditorScreen() {
        let editorViewController = AppFlow.editorView()
        navigationController?.pushViewController(editorViewController, animated: true)
    }
    
    
//     MARK: - Actions

    @objc
    private func joinTapped() {
        
#warning("TODO: need to fix")
        
        guard let email = loginTextField.text,
              viewModel.isValidEmail(email: email)
        else { return createAlert(with: "Email isn't correct") }
        
        viewModel.checkEmailAvailability(email: email) { [weak self] isAvailable, error in
            guard let self = self else { return }
            if let error = error {
//                self.createAlert(with: error.localizedDescription)
            }
            
            if isAvailable {
                guard let password = self.passwordTextField.text,
                      self.viewModel.isValidPassword(password)
                else { return self.createAlert(with: "Email or password isn't correct") }
                
                viewModel.signUp(email: email, password: password) { [weak self] error in
                    self?.goToEditorScreen()
                }
            }
        }
    }
    
    @objc
    private func goToSignInAction() {
        navigationController?.popViewController(animated: true)
    }
}

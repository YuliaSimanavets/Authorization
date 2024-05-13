//
//  RegistrationViewController.swift
//  AuthorizationApp
//
//  Created by Yuliya on 13/05/2024.
//

import UIKit
import SnapKit

class RegistrationViewController: UIViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
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
    
//     MARK: - Actions
    
    @objc
    private func goToSignInAction() {
        navigationController?.popViewController(animated: true)
    }
}

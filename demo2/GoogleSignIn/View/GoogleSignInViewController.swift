//
//  GoogleSignInViewController.swift
//  demo2
//
//  Created by Prashant Kumar Soni on 16/05/25.
//

import UIKit
import SnapKit
import Combine

class GoogleSignInViewController: BaseViewController {
    private let viewModel = GoogleSignInViewModel()
    private let googleSignInButton = UIButton()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bindingViewModel()
    }
    
    private func setupUI() {
        view.addSubview(googleSignInButton)
        googleSignInButtonView()
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            googleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleSignInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            googleSignInButton.heightAnchor.constraint(equalToConstant: 50),
            googleSignInButton.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
}

extension GoogleSignInViewController {
    private func bindingViewModel() {
        viewModel.$loggedIn
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let welf = self else { return }
                
                if value {
                    welf.userSuccessfullyLoggedIn()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: -Google SignIn
extension GoogleSignInViewController {
    private func googleSignInButtonView() {
        googleSignInButton.setTitle("Sign in with Google", for: .normal)
        googleSignInButton.setTitleColor(.black, for: .normal)
        googleSignInButton.backgroundColor = .white
        googleSignInButton.layer.cornerRadius = 8
        googleSignInButton.layer.borderWidth = 1
        googleSignInButton.layer.borderColor = UIColor.lightGray.cgColor
        googleSignInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        googleSignInButton.semanticContentAttribute = .forceLeftToRight

        googleSignInButton.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
    }

    @objc private func btnTapped() {
        Task {
            await viewModel.signInWithGoogle()
        }
    }
}

extension GoogleSignInViewController {
    private func userSuccessfullyLoggedIn() {
        AppUserDefaults.isLoggedIn = true
        NavigateToRootVC.navigateToRootViewController(MainViewController())
    }
}

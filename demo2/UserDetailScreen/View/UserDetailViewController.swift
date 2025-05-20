//
//  UserDetailViewController.swift
//  demo2
//
//  Created by Prashant Kumar Soni on 20/05/25.
//

import UIKit
import Combine

class UserDetailViewController: BaseViewController {
    private let viewModel = UserDetailViewModel()
    
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private var stackView = UIStackView()
    private let loader = UIActivityIndicatorView(style: .large)
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupNavigationBar()
        showUserDetails()
        bindViewModel()
    }
    
    private func setupUI() {
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        nameLabel.textColor = UIColor.black
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        
        emailLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        emailLabel.textColor = UIColor.black
        emailLabel.numberOfLines = 0
        emailLabel.textAlignment = .center
        
        stackView = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func showUserDetails() {
        viewModel.loadUserDetails()
    }
}

extension UserDetailViewController {
    private func bindViewModel() {
        viewModel.$userDetails
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let welf = self else { return }
                
                welf.updateDataInUi(data)
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let welf = self else { return }
                
                welf.showLoader(value)
            }
            .store(in: &cancellables)
    }
    
    private func updateDataInUi(_ data: UserDetailModel?) {
        self.nameLabel.text = data?.name
        self.emailLabel.text = data?.email
    }
    
    private func showLoader(_ show: Bool) {
        DispatchQueue.main.async {
            if show {
                self.loader.startAnimating()
                self.stackView.isHidden = true
            } else {
                self.stackView.isHidden = false
                self.loader.stopAnimating()
            }
        }
    }
}

extension UserDetailViewController {
    private func setupNavigationBar() {
        title = "User Details"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
    }

    @objc private func logoutTapped() {
        AppUserDefaults.isLoggedIn = false
        NavigateToRootVC.navigateToRootViewController(GoogleSignInViewController())
    }
}

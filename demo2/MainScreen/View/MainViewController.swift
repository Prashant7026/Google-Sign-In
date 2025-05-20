//
//  MainViewController.swift
//  demo2
//
//  Created by Prashant Kumar Soni on 19/05/25.
//

import UIKit

class MainViewController: BaseViewController {
    private let imageButton = UIButton()
    private let pdfButton = UIButton()
    private let apiListButton = UIButton()
    private let userDetailsButton = UIButton()
    
    override func viewDidLoad() {
        setupUI()
    }
}

extension MainViewController {
    private func setupUI() {
        setupAllButtons()
        setupStackView()
    }
}

extension MainViewController {
    private func setupAllButtons() {
        let buttons = [imageButton, pdfButton, apiListButton, userDetailsButton]
        let titles = ["Image Capture & Gallery Selection", "PDF Viewer", "API List Screen", "User Details"]
        
        for (button, title) in zip(buttons, titles) {
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 8
            button.translatesAutoresizingMaskIntoConstraints = false
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        imageButton.addTarget(self, action: #selector(imageCaptureBtnTapped), for: .touchUpInside)
        pdfButton.addTarget(self, action: #selector(pdfViewerBtnTapped), for: .touchUpInside)
        apiListButton.addTarget(self, action: #selector(apiListBtnTapped), for: .touchUpInside)
        userDetailsButton.addTarget(self, action: #selector(userDetailsBtnTapped), for: .touchUpInside)
    }
    
    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [imageButton, pdfButton, apiListButton, userDetailsButton])
        stackView.axis = .vertical
        stackView.spacing = 10.0
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// Button Triggers
extension MainViewController {
    @objc private func pdfViewerBtnTapped() {
        self.navigationController?.pushViewController(PdfViewController(), animated: true)
    }
    
    @objc private func imageCaptureBtnTapped() {
        self.navigationController?.pushViewController(ImageViewController(), animated: true)
    }
    
    @objc private func apiListBtnTapped() {
        self.navigationController?.pushViewController(ApiListViewController(), animated: true)
    }
    
    @objc private func userDetailsBtnTapped() {
        self.navigationController?.pushViewController(UserDetailViewController(), animated: true)
    }
}

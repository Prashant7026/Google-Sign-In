//
//  ViewController.swift
//  demo2
//
//  Created by Prashant Kumar Soni on 16/05/25.
//

import UIKit
import SnapKit
import GoogleSignIn
import FirebaseAuth

class ViewController: UIViewController {
    
    let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        print("Hii")
        button.setTitle("Tap", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        button.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
    }


}
extension ViewController {
    @objc private func btnTapped() {
        print("Button Tapped!")
        Task {
            await signInWithGoogle()
        }
    }
    
    func signInWithGoogle() async {
        guard let presentingVC = GetViewController.shared.topViewController() else {
                print("No presenting VC found")
                return
            }

            do {
                let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC)
                let user = result.user

                guard let idToken = user.idToken?.tokenString else {
                    print("Failed to get ID token")
                    return
                }

                let accessToken = user.accessToken.tokenString
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

                let authResult = try await Auth.auth().signIn(with: credential)
                print("Signed in as \(authResult.user.email ?? "unknown")")
            } catch {
                print("Google sign-in failed: \(error.localizedDescription)")
            }
        }
}


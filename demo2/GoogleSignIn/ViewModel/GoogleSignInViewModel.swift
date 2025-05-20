//
//  GoogleSignInViewModel.swift
//  demo2
//
//  Created by Prashant Kumar Soni on 19/05/25.
//

import Foundation
import GoogleSignIn
import FirebaseAuth

class GoogleSignInViewModel: ObservableObject {
    @Published var loggedIn: Bool = false
    
    func signInWithGoogle() async {
        guard let presentingVC = await GetViewController.shared.topViewController() else {
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
            CoreDataManager.shared.saveUserDetails(
                UserDetailModel(name: authResult.user.displayName, email: authResult.user.email)
            )
            loggedIn = true
            print("Signed in as \(authResult.user.email ?? "unknown")")
        } catch {
            print("Google sign-in failed: \(error.localizedDescription)")
        }
    }
    
}

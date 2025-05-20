//
//  UserDetailViewModel.swift
//  demo2
//
//  Created by Prashant Kumar Soni on 20/05/25.
//

import Foundation

class UserDetailViewModel: ObservableObject {
    @Published var userDetails: UserDetailModel?
    @Published var isLoading: Bool = false
    
    func loadUserDetails() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let userEntity = CoreDataManager.shared.getUserDetails()
            
            DispatchQueue.main.async {
                self.userDetails = UserDetailMapperUtil.enitityToUserModel(userEntity: userEntity)
                self.isLoading = false
            }
        }
    }

}

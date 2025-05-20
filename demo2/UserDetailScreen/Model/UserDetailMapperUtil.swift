//
//  UserDetailMapperUtil.swift
//  demo2
//
//  Created by Prashant Kumar Soni on 19/05/25.
//

import Foundation

class UserDetailMapperUtil {
    static func enitityToUserModel(userEntity: UserDetailEntity?) -> UserDetailModel? {
        guard let userEntity = userEntity else { return nil }
        
        let userModel = UserDetailModel(
            name: userEntity.name,
            email: userEntity.email
        )
        
        return userModel
    }
}

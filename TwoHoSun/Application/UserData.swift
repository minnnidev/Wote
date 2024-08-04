//
//  UserData.swift
//  TwoHoSun
//
//  Created by 김민 on 8/4/24.
//

import Foundation

final class UserData: ObservableObject {

    static let shared = UserData()

    @Published var userProfile: UserProfileModel {
        didSet {
            UserDefaults.standard.setObject(userProfile, forKey: UserDefaultsKey.myProfile)
        }
    }

    private init() { 
        if let savedProfile = UserDefaults.standard.getObject(UserProfileModel.self, forKey: UserDefaultsKey.myProfile) {
            userProfile = savedProfile
        } else {
            userProfile = UserProfileModel.init(
                nickname: "",
                profileImage: nil,
                consumerType: nil,
                schoolName: "",
                cantUpdateType: true
            )
        }
    }
}

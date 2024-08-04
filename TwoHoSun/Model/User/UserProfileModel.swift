//
//  UserProfileModel.swift
//  TwoHoSun
//
//  Created by 김민 on 8/4/24.
//

import Foundation

struct UserProfileModel: Codable {
    let nickname: String
    let profileImage: String?
    let consumerType: ConsumerType?
    let schoolName: String
    let typeTestCount: Int
}

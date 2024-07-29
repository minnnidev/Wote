//
//  ProfileResponseObject.swift
//  TwoHoSun
//
//  Created by 김민 on 7/29/24.
//

import Foundation

struct ProfileResponseObject: Codable {
    let createDate: String
    let modifiedDate: String
    let lastSchoolRegisterDate: String
    let nickname: String
    let profileImage: String?
    let consumerType: String
    let school: SchoolObject
    let canUpdateConsumerType: Bool
}

extension ProfileResponseObject {

    func toModel() -> ProfileModel {
        .init(
            createDate: createDate,
            modifiedDate: modifiedDate,
            lastSchoolRegisterDate: lastSchoolRegisterDate,
            nickname: nickname,
            profileImage: profileImage,
            consumerType: consumerType,
            school: school.toModel(),
            canUpdateConsumerType: canUpdateConsumerType
        )
    }
}

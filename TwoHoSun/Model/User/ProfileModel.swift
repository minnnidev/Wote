//
//  ProfileModel.swift
//  TwoHoSun
//
//  Created by 김민 on 7/29/24.
//

import Foundation

struct ProfileModel: Encodable {
    let createDate: String
    let modifiedDate: String
    let lastSchoolRegisterDate: String
    let nickname: String
    let profileImage: String?
    let consumerType: String?
    let school: SchoolModel
    let canUpdateConsumerType: Bool
}

extension ProfileModel {

    static var profileStub: ProfileModel {
        .init(
            createDate: "2024-07-15T14:44:44.993126",
            modifiedDate: "2024-07-17T15:07:21.032732",
            lastSchoolRegisterDate: "2024-07-16",
            nickname: "히히",
            profileImage: "https://www.wote.social/images/posts/78ec4f86-5676-4c70-ae16-0334c452ec72.jpg",
            consumerType: "TRENDSETTER",
            school: .schoolStub,
            canUpdateConsumerType: true
        )
    }
}

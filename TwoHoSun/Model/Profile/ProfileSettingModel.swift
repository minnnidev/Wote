//
//  ProfileSettingModel.swift
//  TwoHoSun
//
//  Created by 관식 on 10/18/23.
//

import SwiftUI

struct ProfileSettingModel: Codable {
    var imageFile: Data?
    var nickname: String
    var school: SchoolModel?
}

extension ProfileSettingModel {

    func toObject() -> ProfileRequestObject {
        .init(
            imageFile: imageFile,
            nickname: nickname,
            school: school?.toObject())
    }
}

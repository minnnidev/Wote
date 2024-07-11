//
//  ProfileRequestObject.swift
//  TwoHoSun
//
//  Created by 김민 on 7/10/24.
//

import Foundation

struct ProfileRequestObject: Codable {
    let imageFile: Data?
    let nickname: String
    let school: SchoolObject? 
}

extension ProfileRequestObject {

    func toModel() -> ProfileSettingModel {
        .init(
            imageFile: imageFile,
            nickname: nickname,
            school: school?.toModel()
        )
    }
}

struct SchoolObject: Codable {
    let schoolName: String
    let schoolRegion: String
}

extension SchoolObject {
    
    func toModel() -> SchoolModel {
        .init(schoolName: schoolName, schoolRegion: schoolRegion)
    }
}

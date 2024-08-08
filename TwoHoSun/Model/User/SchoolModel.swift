//
//  SchoolModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/17/23.
//

import Foundation

struct SchoolModel: Codable {
    let schoolName: String
    let schoolRegion: String
}

extension SchoolModel {
    func toObject() -> SchoolObject {
        .init(schoolName: schoolName, schoolRegion: schoolRegion)
    }
}

struct SchoolInfoModel: Identifiable {
    let id = UUID()
    var school: SchoolModel
    let schoolAddress: String?
}

extension SchoolModel {
    static var schoolStub: SchoolModel {
        .init(schoolName: "샘플고등학교", schoolRegion: "서울")
    }
}

extension SchoolInfoModel {
    static var schoolInfoStub: SchoolInfoModel {
        .init(school: .schoolStub, schoolAddress: "서울시 샘플구")
    }
}

enum SchoolDataType {
    case highSchool, middleSchool

    var schoolParam: String {
        switch self {
        case .highSchool:
            return "high_list"
        case .middleSchool:
            return "midd_list"
        }
    }

    var schoolType: String {
        switch self {
        case .highSchool:
            return "고등학교"
        case .middleSchool:
            return "중학교"
        }
    }
}

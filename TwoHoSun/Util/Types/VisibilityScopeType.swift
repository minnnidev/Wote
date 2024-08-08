//
//  VisibilityScopeType.swift
//  TwoHoSun
//
//  Created by 김민 on 8/8/24.
//

import Foundation

enum VisibilityScopeType: String, Codable {
    case all = "ALL"
    case global = "GLOBAL"
    case school = "SCHOOL"

    var title: String {
        switch self {
        case .all:
            return "전체"
        case .global:
            return "전국 투표"
        case .school:
            return "우리 학교 투표"
        }
    }

    var type: String {
        switch self {
        case .all:
            return "ALL"
        case .global:
            return "GLOBAL"
        case .school:
            return "SCHOOL"
        }
    }
}

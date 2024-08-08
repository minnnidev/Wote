//
//  PostStatus.swift
//  TwoHoSun
//
//  Created by 김민 on 11/17/23.
//

import Foundation

enum PostStatus: String, Codable, CaseIterable {
    case active = "ACTIVE"
    case closed = "CLOSED"
    case review = "REVIEW"

    var filterTitle: String {
        switch self {
        case .active:
            return "진행중인 투표"
        case .closed:
            return "종료된 투표"
        case .review:
            return "후기"
        }
    }
}

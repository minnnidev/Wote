//
//  AuthorObject.swift
//  TwoHoSun
//
//  Created by 김민 on 7/16/24.
//

import Foundation

struct AuthorObject: Codable {
    let id: Int
    let nickname: String
    let profileImage: String?
    let consumerType: String
    let isBlocked: Bool?
    let isBaned: Bool?
}

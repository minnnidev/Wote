//
//  AuthorResponseObject.swift
//  TwoHoSun
//
//  Created by 김민 on 7/16/24.
//

import Foundation

struct AuthorResponseObject: Codable {
    let id: Int
    let nickname: String
    let profileImage: String?
    let consumerType: String
    let isBlocked: Bool?
    let isBaned: Bool?
}

extension AuthorResponseObject {

    func toModel() -> AuthorModel {
        .init(
            id: id,
            nickname: nickname,
            profileImage: profileImage,
            consumerType: consumerType,
            isBlocked: isBlocked,
            isBaned: isBaned
        )
    }
}

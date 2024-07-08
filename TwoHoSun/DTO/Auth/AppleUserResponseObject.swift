//
//  AppleUserResponseObject.swift
//  TwoHoSun
//
//  Created by 김민 on 7/8/24.
//

import Foundation

struct APIResponse: Codable {
    let status: Int
    let message: String
    let data: AppleUserResponseObject
}

struct AppleUserResponseObject: Codable {
    let consumerTypeExist: Bool?
    let jwtToken: TokenObject
}

struct TokenObject: Codable {
    let accessToken: String
    let accessExpirationTime: Int
    let refreshToken: String
    let refreshExpirationTime: Int
}

extension TokenObject {

    func toToken() -> Tokens {
        .init(accessToken: accessToken, refreshToken: refreshToken)
    }
}

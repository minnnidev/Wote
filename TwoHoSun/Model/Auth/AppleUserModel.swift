//
//  AppleUserModel.swift
//  TwoHoSun
//
//  Created by 김민 on 7/8/24.
//

import Foundation

struct AppleUserModel {
    var consumerTypeExist: Bool?
    var jwtToken : Tokens
}

struct Tokens {
    var accessToken: String
    var refreshToken: String
}

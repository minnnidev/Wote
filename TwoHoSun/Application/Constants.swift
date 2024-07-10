//
//  Constants.swift
//  TwoHoSun
//
//  Created by 김민 on 7/8/24.
//

import Foundation

typealias TokenType = Constants.TokenType
typealias AppStorageKey = Constants.AppStorageKey

struct Constants { }

extension Constants {

    struct TokenType {
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
    }

    struct AppStorageKey {
        static let loginState = "loginState"
    }
}

//
//  Constants.swift
//  TwoHoSun
//
//  Created by 김민 on 7/8/24.
//

import Foundation

typealias TokenType = Constants.TokenType
typealias AppStorageKey = Constants.AppStorageKey
typealias APIKey = Constants.APIKeyConst
typealias URLConst = Constants.URLConst

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

extension Constants {

    struct URLConst {

        static var baseURL: String {
            guard let baseURL = Bundle.main.infoDictionary?["BASE_URL"] as? String else {
                fatalError("BASE_URL is missing in the Info.plist")
            }
            return baseURL.replacingOccurrences(of: " ", with: "")
        }

        static var cnetURL: String {
            return "http://www.career.go.kr/cnet/openapi/getOpenApi"
        }
    }
}

extension Constants {

    struct APIKeyConst {
        static var cnetAPIKey: String {
            guard let key = Bundle.main.object(forInfoDictionaryKey: "SCHOOL_API_KEY") as? String else {
                fatalError("SCHOOL_API_KEY error")
            }
            return key
        }
    }
}

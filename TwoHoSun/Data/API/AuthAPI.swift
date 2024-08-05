//
//  AuthAPI.swift
//  TwoHoSun
//
//  Created by 김민 on 7/8/24.
//

import Foundation
import Moya

enum AuthAPI {
    case loginWithApple(AppleUserRequestObject)
    case getNewToken(RefreshTokenRequestObject)
    case postLogout(LogoutRequestObject)
}

extension AuthAPI: TargetType {

    var baseURL: URL {
        URL(string: URLConst.baseURL)!
    }
    
    var path: String {
        switch self {
        case .loginWithApple(_):
            return "/login/oauth2/code/apple"
        case .getNewToken(_):
            return "/api/auth/refresh"
        case .postLogout:
            return "/api/auth/logout"
        }
    }
    
    var method: Moya.Method {
        .post
    }

    var task: Moya.Task {
        switch self {
        case let .loginWithApple(requestObject):
            return .requestParameters(parameters: requestObject.toDictionary(), encoding: URLEncoding.default)

        case let .getNewToken(requestObject):
            return .requestParameters(parameters: requestObject.toDictionary(), encoding: JSONEncoding.default)

        case let .postLogout(requestObject):
            return .requestParameters(parameters: requestObject.toDictionary(), encoding: JSONEncoding.default)

        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .loginWithApple:
            APIConstants.headerXform
        case .getNewToken:
            APIConstants.headerWithOutToken
        case .postLogout:
            APIConstants.headerWithAuthorization
        }
    }

    var validationType: ValidationType {
        return .successCodes
    }
}

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
}

extension AuthAPI: TargetType {

    var baseURL: URL {
        URL(string: URLConst.baseURL)!
    }
    
    var path: String {
        switch self {
        case .loginWithApple(_):
            "/login/oauth2/code/apple"
        case .getNewToken(_):
            "/api/auth/refresh"
        }
    }
    
    var method: Moya.Method {
        .post
    }

    var task: Moya.Task {
        switch self {
        case let .loginWithApple(requestObject):
                .requestParameters(parameters: requestObject.toDictionary(), encoding: URLEncoding.default)
        case let .getNewToken(requestObject):
                .requestParameters(parameters: requestObject.toDictionary(), encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .loginWithApple(_):
            APIConstants.headerXform
        case .getNewToken(_):
            APIConstants.headerWithOutToken
        }
    }

    var validationType: ValidationType {
        return .successCodes
    }
}

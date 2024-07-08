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
}

extension AuthAPI: TargetType {

    var baseURL: URL {
        URL(string: URLConst.baseURL)!
    }
    
    var path: String {
        "/login/oauth2/code/apple"
    }
    
    var method: Moya.Method {
        .post
    }

    var task: Moya.Task {
        switch self {
        case let .loginWithApple(requestObject):
            .requestParameters(parameters: requestObject.toDictionary(), encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        APIConstants.headerXform
    }
}

//
//  UserAPI.swift
//  TwoHoSun
//
//  Created by 김민 on 7/10/24.
//

import Foundation
import Moya

enum UserAPI {
   case checkNicknameDuplicate(NicknameRequestObject)
}

extension UserAPI: TargetType {

    var baseURL: URL {
        URL(string: URLConst.baseURL)!
    }
    
    var path: String {
        switch self {
        case .checkNicknameDuplicate(_):
            "/api/profiles/isValidNickname"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkNicknameDuplicate(_):
                .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .checkNicknameDuplicate(requestObject):
                .requestParameters(parameters: requestObject.toDictionary(), encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            APIConstants.headerWithAuthorization
        }
    }
}

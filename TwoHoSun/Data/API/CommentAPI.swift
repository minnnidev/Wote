//
//  CommentAPI.swift
//  TwoHoSun
//
//  Created by 김민 on 7/31/24.
//

import Foundation
import Moya

enum CommentAPI {
    case getComments(CommentRequestObject)
}

extension CommentAPI: TargetType {

    var baseURL: URL {
        return URL(string: "\(URLConst.baseURL)/api")!
    }
    
    var path: String {
        switch self {
        case .getComments:
            return "/comments"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getComments(_):
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .getComments(requestObject):
            return .requestParameters(parameters: requestObject.toDictionary(), encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return APIConstants.headerWithAuthorization
    }
}

//
//  CommentAPI.swift
//  TwoHoSun
//
//  Created by 김민 on 7/31/24.
//

import Foundation
import Moya

enum CommentAPI {
    case getComments(Int)
}

extension CommentAPI: TargetType {

    var baseURL: URL {
        return URL(string: "\(URLConst.baseURL)/api")!
    }
    
    var path: String {
        switch self {
        case let .getComments(postId):
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
        case let .getComments(postId):
            return .requestParameters(parameters: postId.toDictionary(), encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return APIConstants.headerWithAuthorization
    }
}

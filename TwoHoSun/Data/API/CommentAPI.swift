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
    case postComment(RegisterCommentRequestObject)
}

extension CommentAPI: TargetType {

    var baseURL: URL {
        return URL(string: "\(URLConst.baseURL)/api")!
    }
    
    var path: String {
        switch self {
        case .getComments:
            return "/comments"

        case .postComment:
            return "/comments"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getComments:
            return .get

        case .postComment:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .getComments(requestObject):
            return .requestParameters(parameters: requestObject.toDictionary(), encoding: URLEncoding.queryString)

        case let .postComment(requestObject):
            return .requestParameters(parameters: requestObject.toDictionary(), encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return APIConstants.headerWithAuthorization
    }
}

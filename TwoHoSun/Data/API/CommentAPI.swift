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
    case postSubComment(commentId: Int, RegisterCommentRequestObject)
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

        case let .postSubComment(commentId, _):
            return "/comments/\(commentId)"

        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getComments:
            return .get

        case .postComment:
            return .post

        case .postSubComment:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .getComments(requestObject):
            return .requestParameters(parameters: requestObject.toDictionary(), encoding: URLEncoding.queryString)

        case let .postComment(requestObject):
            return .requestParameters(parameters: requestObject.toDictionary(), encoding: JSONEncoding.default)

        case let .postSubComment(commentId, requestObject):
            return .requestCompositeParameters(
                bodyParameters: requestObject.toDictionary(),
                bodyEncoding: JSONEncoding.default,
                urlParameters: commentId.toDictionary()
            )
        }
    }
    
    var headers: [String : String]? {
        return APIConstants.headerWithAuthorization
    }
}

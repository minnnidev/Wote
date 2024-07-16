//
//  VoteAPI.swift
//  TwoHoSun
//
//  Created by 김민 on 7/16/24.
//

import Foundation
import Moya

enum VoteAPI {
    case getVotes(VoteRequestObject)
    case getVoteDetail(Int)
}

extension VoteAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: URLConst.baseURL)!
    }

    var path: String {
        switch self {
        case .getVotes(_):
            return "api/posts"
        case let .getVoteDetail(postId):
            return "api/posts/\(postId)"
        }
    }

    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case let .getVotes(requestObject):
            return .requestParameters(
                parameters: requestObject.toDictionary(),
                encoding: URLEncoding.queryString
            )
        case let .getVoteDetail(postId):
            return .requestParameters(
                parameters: postId.toDictionary(),
                encoding: URLEncoding.queryString
            )
        }
    }

    var headers: [String : String]? {
        switch self {
        default:
            APIConstants.headerWithAuthorization
        }
    }
}

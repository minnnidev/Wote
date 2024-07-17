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
    case postVote(postId: Int, requestObject: ChooseRequestObject)
}

extension VoteAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "\(URLConst.baseURL)/api")!
    }

    var path: String {
        switch self {
        case .getVotes(_):
            return "/posts"
        case let .getVoteDetail(postId):
            return "/posts/\(postId)"
        case let .postVote(postId, _):
            return "/posts/\(postId)/votes"
        }
    }

    var method: Moya.Method {
        switch self {
        case .postVote(_, _):
            return .post
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
        case let .postVote(postId, requestObject):
            return .requestCompositeParameters(
                bodyParameters: requestObject.toDictionary(),
                bodyEncoding: JSONEncoding.default,
                urlParameters: postId.toDictionary()
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

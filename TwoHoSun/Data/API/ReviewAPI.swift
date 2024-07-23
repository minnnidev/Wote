//
//  ReviewAPI.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation
import Moya

enum ReviewAPI {
    case getReviews(visibilityScope: String)
    case getMoreReviews(MoreReviewRequestObject)
}

extension ReviewAPI: TargetType {

    var baseURL: URL {
        return URL(string: "\(URLConst.baseURL)/api")!
    }

    var path: String {
        switch self {
        case .getReviews:
            return "/reviews"

        case let .getMoreReviews(requestObject):
            return "reviews/\(requestObject.reviewType)"
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
        case let .getReviews(visibilityScope):
            return .requestParameters(parameters: visibilityScope.toDictionary(), encoding: URLEncoding.queryString)
        case let .getMoreReviews(requestObject):
            return .requestParameters(parameters: requestObject.toDictionary(), encoding: URLEncoding.queryString)
        }
    }

    var headers: [String : String]? {
        switch self {
        default:
            APIConstants.headerWithAuthorization
        }
    }

}

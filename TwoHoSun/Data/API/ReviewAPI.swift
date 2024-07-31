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
    case getReviewDetail(reviewId: Int)
    case postReview(postId: Int, ReviewCreateRequestObject)
    case deleteReview(postId: Int)
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

        case let .getReviewDetail(reviewId):
            return "/reviews/\(reviewId)/detail"

        case let .postReview(postId, _):
            return "/posts/\(postId)/reviews"

        case let .deleteReview(postId):
            return "/posts/\(postId)/reviews"
        }
    }

    var method: Moya.Method {
        switch self {
        case .postReview(_, _):
            return .post
        case .deleteReview(_):
            return .delete
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

        case let .getReviewDetail(reviewId):
            return .requestParameters(parameters: reviewId.toDictionary(),
                                      encoding: URLEncoding.queryString)

        case let .postReview(_, requestObject):
            let formData = MultipartFormDataHelper.createMultipartFormData(from: requestObject)
            return .uploadMultipart(formData)

        case let .deleteReview(postId):
            return .requestParameters(parameters: postId.toDictionary(),
                                      encoding: URLEncoding.queryString)
        }
    }

    var headers: [String : String]? {
        switch self {
        default:
            APIConstants.headerWithAuthorization
        }
    }

    var validationType: ValidationType {
        return .successCodes
    }
}

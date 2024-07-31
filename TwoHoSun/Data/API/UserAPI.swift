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
    case getSchoolData(String, SchoolDataType)
    case postProfile(ProfileRequestObject)
    case getMyVotes(MyVotesRequestObject)
    case getMyReviews(MyReviewsRequestObject)
    case getProfile
}

extension UserAPI: TargetType {

    var baseURL: URL {
        switch self {
        case .getSchoolData(_, _):
            URL(string: URLConst.cnetURL)!
        default:
            URL(string: "\(URLConst.baseURL)/api")!
        }
    }
    
    var path: String {
        switch self {
        case .checkNicknameDuplicate(_):
            return "/profiles/isValidNickname"
        case .getSchoolData(_, _):
            return ""
        case .postProfile(_):
            return "/profiles"
        case .getMyVotes(_):
            return "/mypage/posts"
        case .getMyReviews(_):
            return "/mypage/reviews"
        case .getProfile:
            return "/profiles"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkNicknameDuplicate(_):
            return .post
        case .getSchoolData(_, _):
            return .get
        case .postProfile(_):
            return .post
        case .getMyVotes(_):
            return .get
        case .getMyReviews(_):
            return .get
        case .getProfile:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .checkNicknameDuplicate(requestObject):
            return .requestParameters(parameters: requestObject.toDictionary(), encoding: JSONEncoding.default)

        case let .getSchoolData(searchText, schoolType):
            let parameters: [String: Any] = [
                "apiKey": APIKey.cnetAPIKey,
                "svcType": "api",
                "svcCode": "SCHOOL",
                "contentType": "json",
                "gubun": schoolType.schoolParam,
                "searchSchulNm": searchText
            ]

            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
        case let .postProfile(requestObject):
            let formData = MultipartFormDataHelper.createMultipartFormData(from: requestObject)
            return .uploadMultipart(formData)

        case let .getMyVotes(requestObject):
            return .requestParameters(parameters: requestObject.toDictionary(), encoding: URLEncoding.queryString)

        case let .getMyReviews(requestObject):
            return .requestParameters(parameters: requestObject.toDictionary(), encoding: URLEncoding.queryString)

        case .getProfile:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getSchoolData(_, _):
            nil
        case .postProfile(_):
            APIConstants.headerMultiPartForm
        default:
            APIConstants.headerWithAuthorization
        }
    }

    var validationType: ValidationType {
        return .successCodes
    }
}

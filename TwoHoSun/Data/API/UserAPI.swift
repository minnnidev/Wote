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
}

extension UserAPI: TargetType {

    var baseURL: URL {
        switch self {
        case .getSchoolData(_, _):
            URL(string: URLConst.cnetURL)!
        default:
            URL(string: URLConst.baseURL)!
        }
    }
    
    var path: String {
        switch self {
        case .checkNicknameDuplicate(_):
            "/api/profiles/isValidNickname"
        case .getSchoolData(_, _):
            ""
        case .postProfile(_):
            "/api/profiles"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkNicknameDuplicate(_):
                .post
        case .getSchoolData(_, _):
                .get
        case .postProfile(_):
                .post
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

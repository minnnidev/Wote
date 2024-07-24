//
//  SearchAPI.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation
import Moya

enum SearchAPI {
    case getSearchResult(SearchRequestObject)
}

extension SearchAPI: TargetType {
    var baseURL: URL {
        return URL(string: "\(URLConst.baseURL)/api")!
    }
    
    var path: String {
        switch self {
        case .getSearchResult(_):
            return "/search"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSearchResult(_):
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .getSearchResult(requestObject):
            return .requestParameters(parameters: requestObject.toDictionary(), encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getSearchResult(_):
            return APIConstants.headerWithAuthorization
        }
    }
}

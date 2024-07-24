//
//  SearchDataSource.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation
import Combine

protocol SearchDataSourceType {
    func getSearchResults(_ object: SearchRequestObject) -> AnyPublisher<[SearchResponseObject], APIError>
}

final class SearchDataSource: SearchDataSourceType {

    typealias Target = SearchAPI

    private let provider: NetworkProviderType

    init(provider: NetworkProviderType) {
        self.provider = provider
    }

    func getSearchResults(_ object: SearchRequestObject) -> AnyPublisher<[SearchResponseObject], APIError> {
        provider.requestPublisher(Target.getSearchResult(object), [SearchResponseObject].self)
    }
}

//
//  SearchRepository.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation
import Combine

final class SearchRepository: SearchRepositoryType {

    private let searchDataSource: SearchDataSourceType

    init(searchDataSource: SearchDataSourceType) {
        self.searchDataSource = searchDataSource
    }

    func getVoteResults(scope: VisibilityScopeType, postStatus: PostStatus, page: Int, size: Int, keyword: String) -> AnyPublisher<[VoteModel], WoteError> {
        let requestObject: SearchRequestObject = .init(
            postStatus: postStatus.rawValue,
            visibilityScope: scope.rawValue,
            page: page,
            size: size,
            keyword: keyword
        )

        return searchDataSource.getSearchResults(requestObject)
            .map { $0.map { $0.toVoteModel() }}
            .mapError { WoteError.error($0) }
            .eraseToAnyPublisher()
    }

    func getReviewResults(scope: VisibilityScopeType, page: Int, size: Int, keyword: String) -> AnyPublisher<[ReviewModel], WoteError> {
        let requestObject: SearchRequestObject = .init(
            postStatus: PostStatus.review.rawValue,
            visibilityScope: scope.rawValue,
            page: page,
            size: size,
            keyword: keyword
        )

        return searchDataSource.getSearchResults(requestObject)
            .map { $0.map { $0.toReviewModel() }}
            .mapError { WoteError.error($0) }
            .eraseToAnyPublisher()
    }
}

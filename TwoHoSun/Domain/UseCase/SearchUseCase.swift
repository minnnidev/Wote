//
//  SearchUseCase.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation
import Combine

protocol SearchUseCaseType {
    func searchVoteResult(voteStatus: PostStatus, scope: VisibilityScopeType, page: Int, size: Int, keyword: String) -> AnyPublisher<[VoteModel], WoteError>
    func searchReviewResult(scope: VisibilityScopeType, page: Int, size: Int, keyword: String) -> AnyPublisher<[ReviewModel], WoteError>
}

final class SearchUseCase: SearchUseCaseType {

    private let searchRepository: SearchRepositoryType

    init(searchRepository: SearchRepositoryType) {
        self.searchRepository = searchRepository
    }

    func searchVoteResult(voteStatus: PostStatus, scope: VisibilityScopeType, page: Int, size: Int, keyword: String) -> AnyPublisher<[VoteModel], WoteError> {
        searchRepository.getVoteResults(scope: scope, postStatus: voteStatus, page: page, size: size, keyword: keyword)
    }

    func searchReviewResult(scope: VisibilityScopeType, page: Int, size: Int, keyword: String) -> AnyPublisher<[ReviewModel], WoteError> {
        searchRepository.getReviewResults(scope: scope, page: page, size: size, keyword: keyword)
    }
}

final class StubSearchUseCase: SearchUseCaseType {

    func searchVoteResult(voteStatus: PostStatus, scope: VisibilityScopeType, page: Int, size: Int, keyword: String) -> AnyPublisher<[VoteModel], WoteError> {
        Just([.voteStub1])
            .setFailureType(to: WoteError.self)
            .eraseToAnyPublisher()
    }

    func searchReviewResult(scope: VisibilityScopeType, page: Int, size: Int, keyword: String) -> AnyPublisher<[ReviewModel], WoteError> {
        Just([.reviewStub1])
            .setFailureType(to: WoteError.self)
            .eraseToAnyPublisher()
    }
}

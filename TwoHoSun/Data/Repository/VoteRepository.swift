//
//  VoteRepository.swift
//  TwoHoSun
//
//  Created by 김민 on 7/16/24.
//

import Foundation
import Combine

final class VoteRepository: VoteRepositoryType {
    
    private let voteDataSource: VoteDataSourceType

    init(voteDataSource: VoteDataSourceType) {
        self.voteDataSource = voteDataSource
    }

    func getVotes(page: Int, size: Int, scope: VisibilityScopeType) -> AnyPublisher<[VoteModel], WoteError> {
        let requestObject: VoteRequestObject = .init(
            page: page,
            size: size,
            visibilityScope: scope.rawValue
        )

        return voteDataSource.getVotes(requestObject)
            .map { $0.map { $0.toModel() }}
            .mapError { WoteError.error($0) }
            .eraseToAnyPublisher()
    }

    func getVoteDetail(postId: Int) -> AnyPublisher<VoteDetailModel, WoteError> {
        voteDataSource.getVoteDetail(postId)
            .map { $0.toModel() }
            .mapError { WoteError.error($0) }
            .eraseToAnyPublisher()
    }
}

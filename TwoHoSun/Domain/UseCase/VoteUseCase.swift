//
//  VoteUseCase.swift
//  TwoHoSun
//
//  Created by 김민 on 7/16/24.
//

import Foundation
import Combine

protocol VoteUseCaseType {
    func loadVotes(page: Int, size: Int, scope: VisibilityScopeType) -> AnyPublisher<[VoteModel], WoteError>
    func loadVoteDetail(postId: Int) -> AnyPublisher<VoteDetailModel, WoteError>
}

final class VoteUseCase: VoteUseCaseType {

    private let voteRepository: VoteRepositoryType

    init(voteRepository: VoteRepositoryType) {
        self.voteRepository = voteRepository
    }

    func loadVotes(page: Int, size: Int, scope: VisibilityScopeType) -> AnyPublisher<[VoteModel], WoteError> {
        voteRepository.getVotes(page: page, size: size, scope: scope)
            .eraseToAnyPublisher()
    }

    func loadVoteDetail(postId: Int) -> AnyPublisher<VoteDetailModel, WoteError> {
        voteRepository.getVoteDetail(postId: postId)
            .eraseToAnyPublisher()
    }
}

final class StubVoteUseCase: VoteUseCaseType {

    func loadVotes(page: Int, size: Int, scope: VisibilityScopeType) -> AnyPublisher<[VoteModel], WoteError> {
        Just([VoteModel.voteStub1, VoteModel.voteStub2])
            .setFailureType(to: WoteError.self)
            .eraseToAnyPublisher()
    }

    func loadVoteDetail(postId: Int) -> AnyPublisher<VoteDetailModel, WoteError> {
        Empty()
            .eraseToAnyPublisher()
    }
}

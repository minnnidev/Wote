//
//  MyPageUseCase.swift
//  TwoHoSun
//
//  Created by 김민 on 7/29/24.
//

import Foundation
import Combine

protocol MyPageUseCaseType {
    func getMyVotes(page: Int, size: Int) -> AnyPublisher<MyVotesModel, WoteError>
    func getMyReviews(page: Int, size: Int, visibilityScope: VisibilityScopeType) -> AnyPublisher<MyReviewsModel, WoteError>
}

final class MyPageUseCase: MyPageUseCaseType {

    private let userRepository: UserRepositoryType

    init(userRepository: UserRepositoryType) {
        self.userRepository = userRepository
    }

    func getMyVotes(page: Int, size: Int) -> AnyPublisher<MyVotesModel, WoteError> {
        userRepository.getMyVotes(page: page, size: size)
    }

    func getMyReviews(page: Int, size: Int, visibilityScope: VisibilityScopeType) -> AnyPublisher<MyReviewsModel, WoteError> {
        userRepository.getMyReviews(page: page, size: size, visibilityScope: visibilityScope)
    }
}

final class StubMyPageUseCase: MyPageUseCaseType {

    func getMyVotes(page: Int, size: Int) -> AnyPublisher<MyVotesModel, WoteError> {
        Just(MyVotesModel(total: 1, votes: [.myVoteStub]))
            .setFailureType(to: WoteError.self)
            .eraseToAnyPublisher()
    }

    func getMyReviews(page: Int, size: Int, visibilityScope: VisibilityScopeType) -> AnyPublisher<MyReviewsModel, WoteError> {
        Just(MyReviewsModel(total: 1, myReviews: [.reviewStub1]))
            .setFailureType(to: WoteError.self)
            .eraseToAnyPublisher()
    }
}

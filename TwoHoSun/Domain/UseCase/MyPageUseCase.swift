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
}

final class MyPageUseCase: MyPageUseCaseType {

    private let userRepository: UserRepositoryType

    init(userRepository: UserRepositoryType) {
        self.userRepository = userRepository
    }

    func getMyVotes(page: Int, size: Int) -> AnyPublisher<MyVotesModel, WoteError> {
        userRepository.getMyVotes(page: page, size: size)
    }
}

final class StubMyPageUseCase: MyPageUseCaseType {

    func getMyVotes(page: Int, size: Int) -> AnyPublisher<MyVotesModel, WoteError> {
        Just(MyVotesModel(total: 0, votes: []))
            .setFailureType(to: WoteError.self)
            .eraseToAnyPublisher()
    }
}

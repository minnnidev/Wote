//
//  UserUseCase.swift
//  TwoHoSun
//
//  Created by 김민 on 7/10/24.
//

import Foundation
import Combine

protocol UserUseCaseType {
    func checkNicknameDuplicated(_ nickname: String) -> AnyPublisher<Bool, WoteError>
}

final class UserUseCase: UserUseCaseType {
    

    private let userRepository: UserRepositoryType

    init(userRepository: UserRepositoryType) {
        self.userRepository = userRepository
    }

    func checkNicknameDuplicated(_ nickname: String) -> AnyPublisher<Bool, WoteError> {
        userRepository.checkNicknameDuplicated(nickname)
    }
}

final class StubUserUseCase: UserUseCaseType {
    
    func checkNicknameDuplicated(_ nickname: String) -> AnyPublisher<Bool, WoteError> {
        Empty()
            .eraseToAnyPublisher()
    }
}

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
    func searchSchool(_ query: String) -> AnyPublisher<[SchoolInfoModel], WoteError>
    func setProfile(_ profile: ProfileSettingModel) -> AnyPublisher<Void, WoteError>
}

final class UserUseCase: UserUseCaseType {
    
    private let userRepository: UserRepositoryType

    init(userRepository: UserRepositoryType) {
        self.userRepository = userRepository
    }

    func checkNicknameDuplicated(_ nickname: String) -> AnyPublisher<Bool, WoteError> {
        userRepository.checkNicknameDuplicated(nickname)
    }

    func searchSchool(_ query: String) -> AnyPublisher<[SchoolInfoModel], WoteError> {
        userRepository.getSchoolsData(query)
    }

    func setProfile(_ profile: ProfileSettingModel) -> AnyPublisher<Void, WoteError> {
        userRepository.setProfile(profile)
    }
}

final class StubUserUseCase: UserUseCaseType {

    func checkNicknameDuplicated(_ nickname: String) -> AnyPublisher<Bool, WoteError> {
        Just(false)
            .setFailureType(to: WoteError.self)
            .eraseToAnyPublisher()
    }

    func searchSchool(_ query: String) -> AnyPublisher<[SchoolInfoModel], WoteError> {
        Empty()
            .eraseToAnyPublisher()
    }

    func setProfile(_ profile: ProfileSettingModel) -> AnyPublisher<Void, WoteError> {
        Empty()
            .eraseToAnyPublisher()
    }
}

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
    func loadProfile() -> AnyPublisher<ProfileModel, WoteError>
    func loadBlockedUsers() -> AnyPublisher<[BlockedUserModel], WoteError>
    func unblockUser(_ memberId: Int) -> AnyPublisher<Void, WoteError>
    func blockUser(_ memberId: Int) -> AnyPublisher<Void, WoteError>
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

    func loadProfile() -> AnyPublisher<ProfileModel, WoteError> {
        userRepository.getProfile()
    }

    func loadBlockedUsers() -> AnyPublisher<[BlockedUserModel], WoteError> {
        userRepository.getBlockedUsers()
    }

    func unblockUser(_ memberId: Int) -> AnyPublisher<Void, WoteError> {
        userRepository.deleteBlockUser(memberId)
    }

    func blockUser(_ memberId: Int) -> AnyPublisher<Void, WoteError> {
        userRepository.postUserBlock(memberId)
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

    func loadProfile() -> AnyPublisher<ProfileModel, WoteError> {
        Just(ProfileModel.profileStub)
            .setFailureType(to: WoteError.self)
            .eraseToAnyPublisher()
    }

    func loadBlockedUsers() -> AnyPublisher<[BlockedUserModel], WoteError> {
        Just([BlockedUserModel.stubBlockedUser1])
            .setFailureType(to: WoteError.self)
            .eraseToAnyPublisher()
    }

    func unblockUser(_ memberId: Int) -> AnyPublisher<Void, WoteError> {
        Empty()
            .eraseToAnyPublisher()
    }

    func blockUser(_ memberId: Int) -> AnyPublisher<Void, WoteError> {
        Empty()
            .eraseToAnyPublisher()
    }
}

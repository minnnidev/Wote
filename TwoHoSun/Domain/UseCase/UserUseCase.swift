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
    func registerConsumerType(_ consumerType: ConsumerType) -> AnyPublisher<Void, WoteError>
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
            .flatMap {
                self.loadProfile()
                    .map { _ in }
            }
            .eraseToAnyPublisher()
    }

    func loadProfile() -> AnyPublisher<ProfileModel, WoteError> {
        userRepository.getProfile()
            .handleEvents(receiveOutput: { [weak self] profile in
                self?.setProfileInLocal(profile: profile)
            })
            .eraseToAnyPublisher()
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

    func registerConsumerType(_ consumerType: ConsumerType) -> AnyPublisher<Void, WoteError> {
        userRepository.putConsumerType(consumerType)
            .flatMap {
                self.loadProfile()
                    .map { _ in }
            }
            .eraseToAnyPublisher()
    }
}

extension UserUseCase {

    private func setProfileInLocal(profile: ProfileModel) {
        let userProfile: UserProfileModel = .init(
            nickname: profile.nickname,
            profileImage: profile.profileImage,
            consumerType: setConsumerType(profile.consumerType),
            schoolName: profile.school.schoolName,
            cantUpdateType: profile.canUpdateConsumerType
        )

        UserDefaults.standard.setObject(userProfile, forKey: UserDefaultsKey.myProfile)
    }

    private func setConsumerType(_ typeRawValue: String?) -> ConsumerType? {
        if let typeRawValue = typeRawValue {
            return ConsumerType(rawValue: typeRawValue)
        } else {
            return nil
        }
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

    func registerConsumerType(_ consumerType: ConsumerType) -> AnyPublisher<Void, WoteError> {
        Empty()
            .eraseToAnyPublisher()
    }
}

//
//  UserRepository.swift
//  TwoHoSun
//
//  Created by 김민 on 7/10/24.
//

import Foundation
import Combine

final class UserRepository: UserRepositoryType {
    
    private let userDataSource: UserDataSourceType

    init(userDataSource: UserDataSourceType) {
        self.userDataSource = userDataSource
    }

    func checkNicknameDuplicated(_ nickname: String) -> AnyPublisher<Bool, WoteError> {
        let requestObject: NicknameRequestObject = .init(nickname: nickname)

        return userDataSource.checkNicknameDuplicated(requestObject)
            .map { $0.isExist }
            .mapError { WoteError.error($0) }
            .eraseToAnyPublisher()
    }

    func getSchoolsData(_ query: String) -> AnyPublisher<[SchoolInfoModel], WoteError> {
        Publishers.Zip(userDataSource.getHighSchoolData(query), userDataSource.getMiddleSchoolData(query))
            .map { highSchoolObject, middleSchoolObject in
                var schoolResult: [SchoolInfoModel] = .init()

                schoolResult.append(contentsOf: highSchoolObject.dataSearch.content.map { $0.convertToSchoolInfoModel() })
                schoolResult.append(contentsOf: middleSchoolObject.dataSearch.content.map { $0.convertToSchoolInfoModel() })

                return schoolResult
            }
            .mapError { WoteError.error($0) }
            .eraseToAnyPublisher()
    }

    func setProfile(_ profile: ProfileSettingModel) -> AnyPublisher<Void, WoteError> {
        userDataSource.setProfile(profile.toObject())
            .mapError { WoteError.error($0) }
            .eraseToAnyPublisher()
    }

    func getMyVotes(page: Int, size: Int) -> AnyPublisher<MyVotesModel, WoteError> {
        let requestObject: MyVotesRequestObject = .init(page: page, size: size)

        return userDataSource.getMyVotes(requestObject)
            .map { $0.toModel() }
            .mapError { WoteError.error($0) }
            .eraseToAnyPublisher()
    }

    func getMyReviews(page: Int, size: Int, visibilityScope: VisibilityScopeType) -> AnyPublisher<MyReviewsModel, WoteError> {
        let requestObject: MyReviewsRequestObject = .init(
            visibilityScope: visibilityScope.rawValue,
            page: page,
            size: size
        )

        return userDataSource.getMyReviews(requestObject)
            .map { $0.toModel() }
            .mapError { WoteError.error($0) }
            .eraseToAnyPublisher()
    }

    func getProfile() -> AnyPublisher<ProfileModel, WoteError> {
        userDataSource.getProfile()
            .map { $0.toModel() }
            .mapError { WoteError.error($0) }
            .eraseToAnyPublisher()
    }

    func getBlockedUsers() -> AnyPublisher<[BlockedUserModel], WoteError> {
        userDataSource.getBlockedUsers()
            .map { $0.map { $0.toModel() } }
            .mapError { WoteError.error($0) }
            .eraseToAnyPublisher()
    }
}

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

    func getSchoolsData(_ query: String) async throws -> [SchoolInfoModel] {
        [.schoolInfoStub]
    }
}

final class StubUserRepository: UserRepositoryType {
    
    func checkNicknameDuplicated(_ nickname: String) -> AnyPublisher<Bool, WoteError> {
        Empty()
            .eraseToAnyPublisher()
    }

    func getSchoolsData(_ query: String) async throws -> [SchoolInfoModel] {
        [.schoolInfoStub]
    }
}

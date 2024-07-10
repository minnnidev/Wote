//
//  AuthRepository.swift
//  TwoHoSun
//
//  Created by 김민 on 7/8/24.
//

import Foundation
import Combine

import Moya

final class AuthRepository: AuthRepositoryType {

    private let authDataSource: AuthDataSourceType

    init(authDataSource: AuthDataSourceType) {
        self.authDataSource = authDataSource
    }


    func loginWithApple(_ authorizationCode: String) -> AnyPublisher<User, CustomError> {
        let object: AppleUserRequestObject = .init(code: authorizationCode, state: "APPLE")

        return authDataSource.loginWithApple(object)
            .map { object in
                if object.message == "Not Completed SignUp Exception" {
                    let user: User = .init(authenticationState: .notCompletedSetting, tokens: object.appleUserResponseObject.jwtToken.toToken())
                    return user
                }

                return User(authenticationState: .authenticated, tokens: object.appleUserResponseObject.jwtToken.toToken())
            }
            .eraseToAnyPublisher()
    }
}

final class StubAuthRepository: AuthRepositoryType {

    func loginWithApple(_ authorizationCode: String) -> AnyPublisher<User, CustomError> {
        Empty()
            .eraseToAnyPublisher()
    }
}

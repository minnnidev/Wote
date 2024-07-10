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

    func loginWithApple(_ authorizationCode: String) -> AnyPublisher<User, WoteError> {
        let object: AppleUserRequestObject = .init(code: authorizationCode, state: "APPLE")

        return authDataSource.loginWithApple(object)
            .map { object in
                let user: User = .init(
                    authenticationState: .authenticated,
                    tokens: object.jwtToken.toToken())

                return user
            }
            .mapError { error -> WoteError in
                switch error {
                case let .notCompletedSignUp(tokenObject):
                    .notCompletedSignUp(token: tokenObject.toToken())

                default:
                    WoteError.error(error)
                }
            }
            .catch { error -> AnyPublisher<User, WoteError> in
                switch error {
                case let .notCompletedSignUp(tokens):
                    let user: User = .init(
                        authenticationState: .notCompletedSetting,
                        tokens: tokens)

                    return Just(user)
                        .setFailureType(to: WoteError.self)
                        .eraseToAnyPublisher()

                default:
                    return Fail(error: WoteError.authenticateFailed)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}

final class StubAuthRepository: AuthRepositoryType {

    func loginWithApple(_ authorizationCode: String) -> AnyPublisher<User, WoteError> {
        Empty()
            .eraseToAnyPublisher()
    }
}

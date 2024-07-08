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


    func loginWithApple(_ authorizationCode: String) -> AnyPublisher<Tokens, CustomError> {
        let object: AppleUserRequestObject = .init(code: authorizationCode, state: "APPLE")

        return authDataSource.loginWithApple(object)
            .map { $0.jwtToken }
            .map { $0.toToken() }
            .eraseToAnyPublisher()
    }
}

final class StubAuthRepository: AuthRepositoryType {

    func loginWithApple(_ authorizationCode: String) -> AnyPublisher<Tokens, CustomError> {
        Empty()
            .eraseToAnyPublisher()
    }
}

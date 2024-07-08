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

    private let provider = MoyaProvider<AuthAPI>()

    func loginWithApple(_ authorizationCode: String) -> AnyPublisher<Tokens, CustomError> {
        let object: AppleUserRequestObject = .init(code: authorizationCode, state: "APPLE")

        return provider.requestPublisher(.loginWithApple(object))
            .tryMap { try JSONDecoder().decode(GeneralResponse<AppleUserResponseObject>.self, from: $0.data) }
            .compactMap { $0.data }
            .map { $0.jwtToken }
            .map { $0.toToken() }
            .mapError { CustomError.error($0) }
            .eraseToAnyPublisher()
    }
}

final class StubAuthRepository: AuthRepositoryType {

    func loginWithApple(_ authorizationCode: String) -> AnyPublisher<Tokens, CustomError> {
        Empty()
            .eraseToAnyPublisher()
    }
}

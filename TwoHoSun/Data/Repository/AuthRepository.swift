//
//  AuthRepository.swift
//  TwoHoSun
//
//  Created by 김민 on 7/8/24.
//

import Foundation
import Combine

import Moya

enum TestError: Error {
    case error(Error)
}

final class AuthRepository: AuthRepositoryType, Networkable {

    typealias target = AuthAPI

    private let test = MoyaProvider<AuthAPI>()

    func signIn(_ authorizationCode: String) -> AnyPublisher<Tokens, TestError> {
        let object: AppleUserRequestObject = .init(code: authorizationCode, state: "APPLE")

        return test.requestPublisher(.loginWithApple(object))
            .tryMap { try JSONDecoder().decode(APIResponse.self, from: $0.data) }
            .map(\.data)
            .map { $0.jwtToken }
            .map { $0.toToken() }
            .mapError { TestError.error($0) }
            .eraseToAnyPublisher()
    }
}

final class StubAuthRepository: AuthRepositoryType {

    func signIn(_ authorizationCode: String) -> AnyPublisher<Tokens, TestError> {
        Empty()
            .eraseToAnyPublisher()
    }
}

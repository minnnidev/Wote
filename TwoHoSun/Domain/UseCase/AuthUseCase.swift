//
//  AuthUseCase.swift
//  TwoHoSun
//
//  Created by 김민 on 7/8/24.
//

import Foundation
import AuthenticationServices
import Combine

protocol AuthUseCaseType {
    func loginWithApple(_ authorization: ASAuthorization) -> AnyPublisher<AuthenticationState, WoteError>
    func logout(_ deviceToken: String) -> AnyPublisher<Void, WoteError>
}

final class AuthUseCase: AuthUseCaseType {
    
    private let authRepository: AuthRepositoryType

    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
    }

    func loginWithApple(_ authorization: ASAuthorization) -> AnyPublisher<AuthenticationState, WoteError> {
        let code = getCredential(authorization)

        return authRepository.loginWithApple(code)
            .handleEvents(receiveOutput: { user in
                KeychainManager.shared.save(key: TokenType.accessToken, token: user.tokens.accessToken)
                KeychainManager.shared.save(key: TokenType.refreshToken, token: user.tokens.refreshToken)
            })
            .map { $0.authenticationState }
            .eraseToAnyPublisher()
    }

    func logout(_ deviceToken: String) -> AnyPublisher<Void, WoteError> {
        authRepository.logout(deviceToken)
    }
}

extension AuthUseCase {

    private func getCredential(_ authorization: ASAuthorization) -> String {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return "" }
        guard let authorizationCode = credential.authorizationCode else { return "" }
        guard let authoriazationCodeString = String(data: authorizationCode, encoding: .utf8) else { return "" }

        return authoriazationCodeString
    }
}

final class StubAuthUseCase: AuthUseCaseType {

    func loginWithApple(_ authorization: ASAuthorization) -> AnyPublisher<AuthenticationState, WoteError> {
        Empty()
            .eraseToAnyPublisher()
    }

    func logout(_ deviceToken: String) -> AnyPublisher<Void, WoteError> {
        Empty()
            .eraseToAnyPublisher()
    }
}

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
    func loginWithApple(_ authorization: ASAuthorization) -> AnyPublisher<Void, CustomError>
}

final class AuthUseCase: AuthUseCaseType {
    
    private let authRepository: AuthRepositoryType

    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
    }

    func loginWithApple(_ authorization: ASAuthorization) -> AnyPublisher<Void, CustomError> {
        let code = getCredential(authorization)

        return authRepository.loginWithApple(code)
            .map { token in
                KeychainManager.shared.save(key: TokenType.accessToken, token: token.accessToken)
                KeychainManager.shared.save(key: TokenType.refreshToken, token: token.refreshToken)
            }
            .eraseToAnyPublisher()
    }
}

extension AuthUseCase {

    func getCredential(_ authorization: ASAuthorization) -> String {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return "" }
        guard let authorizationCode = credential.authorizationCode else { return "" }
        guard let authoriazationCodeString = String(data: authorizationCode, encoding: .utf8) else { return "" }

        return authoriazationCodeString
    }
}

final class StubAuthUseCase: AuthUseCaseType {

    func loginWithApple(_ authorization: ASAuthorization) -> AnyPublisher<Void, CustomError> {
        Empty()
            .eraseToAnyPublisher()
    }
}

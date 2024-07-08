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
    func loginWithApple(_ authorization: ASAuthorization) -> AnyPublisher<Void, TestError>
}

final class AuthUseCase: AuthUseCaseType {
    
    private let authRepository: AuthRepositoryType

    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
    }

    func loginWithApple(_ authorization: ASAuthorization) -> AnyPublisher<Void, TestError> {
        let code = getCredential(authorization)

        return authRepository.signIn(code)
            .map { 
                print($0)
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

    func loginWithApple(_ authorization: ASAuthorization) -> AnyPublisher<Void, TestError> {
        Empty()
            .eraseToAnyPublisher()
    }
}

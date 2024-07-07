//
//  AuthUseCase.swift
//  TwoHoSun
//
//  Created by 김민 on 7/8/24.
//

import Foundation
import AuthenticationServices

protocol AuthUseCaseType {

}

final class AuthUseCase: AuthUseCaseType {
    
    private let authRepository: AuthRepositoryType

    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
    }
}

final class StubAuthUseCase: AuthUseCaseType {
    
}

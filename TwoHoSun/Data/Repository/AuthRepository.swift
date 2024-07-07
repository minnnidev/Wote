//
//  AuthRepository.swift
//  TwoHoSun
//
//  Created by 김민 on 7/8/24.
//

import Foundation

final class AuthRepository: AuthRepositoryType {

    private let authDataSource: AuthDataSourceType

    init(authDataSource: AuthDataSourceType) {
        self.authDataSource = authDataSource
    }
}

final class StubAuthRepository: AuthRepositoryType {

}

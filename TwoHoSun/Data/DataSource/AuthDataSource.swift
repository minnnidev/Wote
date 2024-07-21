//
//  AuthDataSource.swift
//  TwoHoSun
//
//  Created by 김민 on 7/9/24.
//

import Foundation
import Moya
import Combine

protocol AuthDataSourceType {
    func loginWithApple(_ object: AppleUserRequestObject) -> AnyPublisher<AppleUserResponseObject, APIError>
}

final class AuthDataSource: AuthDataSourceType {

    typealias Target = AuthAPI

    private let provider: NetworkProviderType

    init(provider: NetworkProviderType) {
        self.provider = provider
    }

    func loginWithApple(_ object: AppleUserRequestObject) -> AnyPublisher<AppleUserResponseObject, APIError> {
        provider.requestLoginPublisher(Target.loginWithApple(object))
    }
}

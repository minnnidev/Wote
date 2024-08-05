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
    func logout(_ object: LogoutRequestObject) -> AnyPublisher<Void, APIError>
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

    func logout(_ object: LogoutRequestObject) -> AnyPublisher<Void, APIError> {
        provider.requestVoidPublisher(Target.postLogout(object))
    }
}

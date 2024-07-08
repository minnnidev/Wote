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
    func loginWithApple(_ object: AppleUserRequestObject) -> AnyPublisher<AppleUserResponseObject, CustomError>
}

final class AuthDataSource: AuthDataSourceType {

    private let provider = MoyaProvider<AuthAPI>()

    func loginWithApple(_ object: AppleUserRequestObject) -> AnyPublisher<AppleUserResponseObject, CustomError> {
        provider.requestPublisher(.loginWithApple(object))
            .tryMap { try JSONDecoder().decode(GeneralResponse<AppleUserResponseObject>.self, from: $0.data) }
            .compactMap { $0.data }
            .mapError { CustomError.error($0) }
            .eraseToAnyPublisher()
    }
}

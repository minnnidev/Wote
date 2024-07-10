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
    func loginWithApple(_ object: AppleUserRequestObject) -> AnyPublisher<AppleUserResponseObjectWithMessage, CustomError>
}

final class AuthDataSource: AuthDataSourceType {

    private let provider = MoyaProvider<AuthAPI>()

    func loginWithApple(_ object: AppleUserRequestObject) -> AnyPublisher<AppleUserResponseObjectWithMessage, CustomError> {
        provider.requestPublisher(.loginWithApple(object))
            .tryMap {
                let decodedResponse = try JSONDecoder().decode(GeneralResponse<AppleUserResponseObject>.self, from: $0.data)

                guard let data = decodedResponse.data else {
                    throw CustomError.test
                }

                let responseObjectWithMessage: AppleUserResponseObjectWithMessage = .init(
                    message: decodedResponse.message,
                    appleUserResponseObject: decodedResponse.data!
                )

                return responseObjectWithMessage
            }
            .mapError { CustomError.error($0) }
            .eraseToAnyPublisher()
    }
}

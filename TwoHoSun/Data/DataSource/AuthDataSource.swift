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

    private let provider = MoyaProvider<AuthAPI>()

    func loginWithApple(_ object: AppleUserRequestObject) -> AnyPublisher<AppleUserResponseObject, APIError> {

        provider.requestPublisher(.loginWithApple(object))
            .tryMap { response in
                let decodedResponse = try JSONDecoder().decode(GeneralResponse<AppleUserResponseObject>.self, from: response.data)

                if let divisionCode = decodedResponse.divisionCode,
                   let tokens = decodedResponse.data?.jwtToken,
                   divisionCode == "E009" {
                    let tokens: TokenObject = tokens
                    
                    throw APIError.notCompletedSignUp(token: tokens)
                }

                return decodedResponse
            }
            .compactMap { $0.data }
            .mapError { error in
                if let apiError = error as? APIError {
                    apiError
                } else {
                    APIError.error(error)
                }
            }
            .eraseToAnyPublisher()
    }
}

//
//  NetworkProvider.swift
//  TwoHoSun
//
//  Created by 김민 on 7/19/24.
//

import Foundation
import Combine
import Moya

protocol NetworkProviderType: AnyObject {

    func requestPublisher<U: Decodable>(
        _ target: TargetType,
        _ responseType: U.Type
    ) -> AnyPublisher<U, APIError>

    func requestVoidPublisher(_ target: TargetType) -> AnyPublisher<Void, APIError>

    func requestLoginPublisher(_ target: TargetType) -> AnyPublisher<AppleUserResponseObject, APIError>
}

class NetworkProvider: NetworkProviderType {

    static let shared = NetworkProvider()

    private let provider: MoyaProvider<MultiTarget>

    private init() {
        let session = Session(interceptor: AuthInterceptor.shared)
        self.provider = MoyaProvider<MultiTarget>(session: session)
    }

    func requestPublisher<U: Decodable>(_ target: TargetType, _ responseType: U.Type) -> AnyPublisher<U, APIError> {
        provider.requestPublisher(MultiTarget(target))
            .tryMap { response in
                let decodedResponse = try JSONDecoder().decode(GeneralResponse<U>.self, from: response.data)

                guard let data = decodedResponse.data else {
                    throw APIError.decodingError
                }
                return data
            }
            .mapError { error in
                if let moyaError = error as? MoyaError {
                    return APIError.moyaError(moyaError)
                } else if let apiError = error as? APIError {
                    return apiError
                } else {
                    return APIError.error(error)
                }
            }
            .eraseToAnyPublisher()
    }

    func requestVoidPublisher(_ target: TargetType) -> AnyPublisher<Void, APIError> {
        provider.requestPublisher(MultiTarget(target))
            .map { _ in }
            .mapError { APIError.error($0) }
            .eraseToAnyPublisher()
    }

    func requestLoginPublisher(_ target: TargetType) -> AnyPublisher<AppleUserResponseObject, APIError> {
        provider.requestPublisher(MultiTarget(target))
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
                if let moyaError = error as? MoyaError {
                    return APIError.moyaError(moyaError)
                } else if let apiError = error as? APIError {
                    return apiError
                } else {
                    return APIError.error(error)
                }
            }
            .eraseToAnyPublisher()
    }
}


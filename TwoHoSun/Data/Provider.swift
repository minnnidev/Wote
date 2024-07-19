//
//  Provider.swift
//  TwoHoSun
//
//  Created by 김민 on 7/19/24.
//

import Foundation
import Combine
import Moya

protocol ProviderType {
    var provider: MoyaProvider<MultiTarget> { get }

    func requestPublisher<T: TargetType, U: Decodable>(
        _ target: T,
        _ responseType: U.Type
    ) -> AnyPublisher<U, APIError>
}

extension ProviderType {

    func requestPublisher<T: TargetType, U: Decodable>(_ target: T, _ responseType: U.Type) -> AnyPublisher<U, APIError> {
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
                    return APIError.error(moyaError)
                } else if let apiError = error as? APIError {
                    return apiError
                } else {
                    return APIError.error(error)
                }
            }
            .eraseToAnyPublisher()
    }
}


class Provider: ProviderType {

    static let shared = Provider()

    var provider: MoyaProvider<MultiTarget>

    private init(provider: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>(session: Session(interceptor: AuthInterceptor.shared))) {
        self.provider = provider
    }
}


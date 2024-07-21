//
//  Provider.swift
//  TwoHoSun
//
//  Created by 김민 on 7/19/24.
//

import Foundation
import Combine
import Moya

protocol NetworkProviderType: AnyObject {
    associatedtype Target: TargetType

    func requestPublisher<U: Decodable>(
        _ target: Target,
        _ responseType: U.Type
    ) -> AnyPublisher<U, APIError>
}

class NetworkProvider<Target: TargetType>: NetworkProviderType {

    private let provider: MoyaProvider<Target>

    init() {
        let session = Session(interceptor: AuthInterceptor.shared)
        self.provider = MoyaProvider<Target>(session: session)
    }

    func requestPublisher<U>(_ target: Target, _ responseType: U.Type) -> AnyPublisher<U, APIError> where U : Decodable {
        provider.requestPublisher(target)
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


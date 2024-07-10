//
//  UserDataSource.swift
//  TwoHoSun
//
//  Created by 김민 on 7/10/24.
//

import Foundation
import Moya
import Combine

protocol UserDataSourceType {
    func checkNicknameDuplicated(_ object: NicknameRequestObject) -> AnyPublisher<NicknameResponseObject, CustomError>
}

final class UserDataSource: UserDataSourceType {

    private let provider = MoyaProvider<UserAPI>(session: Session(interceptor: AuthInterceptor()))

    func checkNicknameDuplicated(_ object: NicknameRequestObject) -> AnyPublisher<NicknameResponseObject, CustomError> {
        provider.requestPublisher(.checkNicknameDuplicate(object))
            .tryMap { try JSONDecoder().decode(GeneralResponse<NicknameResponseObject>.self, from: $0.data) }
            .compactMap { $0.data }
            .mapError { CustomError.error($0) }
            .eraseToAnyPublisher()
    }

}

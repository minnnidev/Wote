//
//  UserDataSource.swift
//  TwoHoSun
//
//  Created by 김민 on 7/10/24.
//

import Foundation
import Combine
import Moya
import Alamofire

protocol UserDataSourceType {
    func checkNicknameDuplicated(_ object: NicknameRequestObject) -> AnyPublisher<NicknameResponseObject, APIError>
    func getHighSchoolData(_ searchText: String) -> AnyPublisher<HighSchoolResponseObject, APIError>
    func getMiddleSchoolData(_ searchText: String) -> AnyPublisher<MiddleSchoolResponseObject, APIError>
    func setProfile(_ object: ProfileRequestObject) -> AnyPublisher<Void, APIError>
}

final class UserDataSource: UserDataSourceType {

    private let provider = MoyaProvider<UserAPI>(session: Session(interceptor: AuthInterceptor.shared))

    func checkNicknameDuplicated(_ object: NicknameRequestObject) -> AnyPublisher<NicknameResponseObject, APIError> {
        provider.requestPublisher(.checkNicknameDuplicate(object))
            .tryMap { try JSONDecoder().decode(GeneralResponse<NicknameResponseObject>.self, from: $0.data) }
            .compactMap { $0.data }
            .mapError { APIError.error($0) }
            .eraseToAnyPublisher()
    }

    func getHighSchoolData(_ searchText: String) -> AnyPublisher<HighSchoolResponseObject, APIError> {
        provider.requestPublisher(.getSchoolData(searchText, .highSchool))
            .tryMap { try JSONDecoder().decode(HighSchoolResponseObject.self, from: $0.data) }
            .mapError { APIError.error($0) }
            .eraseToAnyPublisher()
    }

    func getMiddleSchoolData(_ searchText: String) -> AnyPublisher<MiddleSchoolResponseObject, APIError> {
        provider.requestPublisher(.getSchoolData(searchText, .middleSchool))
            .tryMap { try JSONDecoder().decode(MiddleSchoolResponseObject.self, from: $0.data) }
            .mapError { APIError.error($0) }
            .eraseToAnyPublisher()
    }

    func setProfile(_ object: ProfileRequestObject) -> AnyPublisher<Void, APIError> {
        provider.requestPublisher(.postProfile(object))
            .map { _ in }
            .mapError { APIError.error($0) }
            .eraseToAnyPublisher()
    }
}

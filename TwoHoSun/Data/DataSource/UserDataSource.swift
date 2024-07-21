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

    typealias Target = UserAPI

    private let provider: NetworkProviderType

    init(provider: NetworkProviderType) {
        self.provider = provider
    }

    func checkNicknameDuplicated(_ object: NicknameRequestObject) -> AnyPublisher<NicknameResponseObject, APIError> {
        provider.requestPublisher(Target.checkNicknameDuplicate(object), NicknameResponseObject.self)
    }

    func getHighSchoolData(_ searchText: String) -> AnyPublisher<HighSchoolResponseObject, APIError> {
        provider.requestPublisher(Target.getSchoolData(searchText, .highSchool), HighSchoolResponseObject.self)
    }

    func getMiddleSchoolData(_ searchText: String) -> AnyPublisher<MiddleSchoolResponseObject, APIError> {
        provider.requestPublisher(Target.getSchoolData(searchText, .middleSchool), MiddleSchoolResponseObject.self)
    }

    func setProfile(_ object: ProfileRequestObject) -> AnyPublisher<Void, APIError> {
        provider.requestVoidPublisher(Target.postProfile(object))
    }
}

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
    func getMyVotes(_ object: MyVotesRequestObject) -> AnyPublisher<MyVotesResponseObject, APIError>
    func getMyReviews(_ object: MyReviewsRequestObject) -> AnyPublisher<MyReviewsReponseObject, APIError>
    func getProfile() -> AnyPublisher<ProfileResponseObject, APIError>
    func getBlockedUsers() -> AnyPublisher<[BlockedUserResponse], APIError>
    func deleteBlockUser(_ memberId: Int) -> AnyPublisher<Void, APIError>
    func postUserBlock(_ memberId: Int) -> AnyPublisher<Void, APIError>
    func putConsumerType(_ object: ConsumerTypeRequestObject) -> AnyPublisher<Void, APIError>
    func postWithDraw() -> AnyPublisher<Void, APIError>
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

    func getMyVotes(_ object: MyVotesRequestObject) -> AnyPublisher<MyVotesResponseObject, APIError> {
        provider.requestPublisher(Target.getMyVotes(object), MyVotesResponseObject.self)
    }

    func getMyReviews(_ object: MyReviewsRequestObject) -> AnyPublisher<MyReviewsReponseObject, APIError> {
        provider.requestPublisher(Target.getMyReviews(object), MyReviewsReponseObject.self)
    }

    func getProfile() -> AnyPublisher<ProfileResponseObject, APIError> {
        provider.requestPublisher(Target.getProfile, ProfileResponseObject.self)
    }

    func getBlockedUsers() -> AnyPublisher<[BlockedUserResponse], APIError> {
        provider.requestPublisher(Target.getBlockedUsers, [BlockedUserResponse].self)
    }

    func deleteBlockUser(_ memberId: Int) -> AnyPublisher<Void, APIError> {
        provider.requestVoidPublisher(Target.deleteBlockUser(memberId: memberId))
    }

    func postUserBlock(_ memberId: Int) -> AnyPublisher<Void, APIError> {
        provider.requestVoidPublisher(Target.postUserBlock(memberId: memberId))
    }

    func putConsumerType(_ object: ConsumerTypeRequestObject) -> AnyPublisher<Void, APIError> {
        provider.requestVoidPublisher(Target.putConsumerType(object))
    }

    func postWithDraw() -> AnyPublisher<Void, APIError> {
        provider.requestVoidPublisher(Target.postWithDraw)
    }
}

//
//  UserRepositoryType.swift
//  TwoHoSun
//
//  Created by 김민 on 7/10/24.
//

import Foundation
import Combine

protocol UserRepositoryType {
    func checkNicknameDuplicated(_ nickname: String) -> AnyPublisher<Bool, WoteError>
    func getSchoolsData(_ query: String) -> AnyPublisher<[SchoolInfoModel], WoteError>
    func setProfile(_ profile: ProfileSettingModel) -> AnyPublisher<Void, WoteError>
    func getMyVotes(page: Int, size: Int) -> AnyPublisher<MyVotesModel, WoteError>
    func getMyReviews(page: Int, size: Int, visibilityScope: VisibilityScopeType) -> AnyPublisher<MyReviewsModel, WoteError>
    func getProfile() -> AnyPublisher<ProfileModel, WoteError>
    func getBlockedUsers() -> AnyPublisher<[BlockedUserModel], WoteError>
    func deleteBlockUser(_ memberId: Int) -> AnyPublisher<Void, WoteError>
    func postUserBlock(_ memberId: Int) -> AnyPublisher<Void, WoteError>
    func putConsumerType(_ consumerType: ConsumerType) -> AnyPublisher<Void, WoteError>
}

//
//  MyPageViewModel.swift
//  TwoHoSun
//
//  Created by 관식 on 11/17/23.
//

import Combine
import SwiftUI

final class MyPageViewModel: ObservableObject {

    enum Action {
        case loadMyProfile
        case loadMyVotes
        case loadMoreVotes
        case loadMyReviews
        case loadMoreReviews
        case changeSelectedType(_ type: MyPageListType)
    }

    @Published var selectedMyPageListType: MyPageListType = .myVote {
        didSet {
            if selectedMyPageListType == .myVote {
                send(action: .loadMyVotes)
            } else {
                send(action: .loadMyReviews)
            }
        }
    }
    @Published var isLoading: Bool = false
    @Published var myProfile: UserProfileModel?
    @Published var myVotes: [MyVoteModel] = .init()
    @Published var myReviews: [ReviewModel] = .init()
    @Published var total: Int = 0

    private var votePage: Int = 0
    private var reviewpage: Int = 0
    private var cacellabels: Set<AnyCancellable> = []

    private let myPageUseCase: MyPageUseCaseType
    private let userUseCase: UserUseCaseType

    init(myPageUseCase: MyPageUseCaseType, userUseCase: UserUseCaseType) {
        self.myPageUseCase = myPageUseCase
        self.userUseCase = userUseCase
    }

    func send(action: Action) {
        switch action {

        case .loadMyProfile:
            if let savedProfile = UserDefaults.standard.getObject(UserProfileModel.self, forKey: UserDefaultsKey.myProfile) {
                myProfile = savedProfile
            } else {
                userUseCase.loadProfile()
                    .sink { _ in
                    } receiveValue: { [weak self] profile in
                        let myProfle: UserProfileModel = .init(
                            nickname: profile.nickname,
                            profileImage: profile.profileImage,
                            consumerType: self?.setConsumerType(profile.consumerType),
                            schoolName: profile.school.schoolName,
                            cantUpdateType: profile.canUpdateConsumerType
                        )

                        self?.myProfile = myProfle
                    }
                    .store(in: &cacellabels)
            }

        case .loadMyVotes:
            isLoading = true
            votePage = 0

            myPageUseCase.getMyVotes(page: votePage, size: 10)
                .sink { [weak self] _ in
                    self?.isLoading = false
                } receiveValue: { [weak self] myVoteModel in
                    self?.myVotes = myVoteModel.votes
                    self?.total = myVoteModel.total
                    self?.isLoading = false
                }
                .store(in: &cacellabels)

        case .loadMoreVotes:
            votePage += 1

            myPageUseCase.getMyVotes(page: votePage, size: 10)
                .sink { _ in
                } receiveValue: { [weak self] myVoteModel in
                    self?.myVotes.append(contentsOf: myVoteModel.votes)
                    self?.total = myVoteModel.total
                }
                .store(in: &cacellabels)

        case .loadMyReviews:
            isLoading = true
            reviewpage = 0

            myPageUseCase.getMyReviews(page: reviewpage, size: 10, visibilityScope: .global)
                .sink { [weak self] _ in
                    self?.isLoading = false
                } receiveValue: { [weak self] myReviewModel in
                    self?.isLoading = false
                    self?.total = myReviewModel.total
                    self?.myReviews = myReviewModel.myReviews
                }
                .store(in: &cacellabels)

        case .loadMoreReviews:
            reviewpage += 1

            myPageUseCase.getMyReviews(page: reviewpage, size: 10, visibilityScope: .global)
                .sink { _ in
                } receiveValue: { [weak self] myReviewModel in
                    self?.total = myReviewModel.total
                    self?.myReviews.append(contentsOf: myReviewModel.myReviews)
                }
                .store(in: &cacellabels)

        case let .changeSelectedType(type):
            selectedMyPageListType = type
        }
    }

    private func setConsumerType(_ typeString: String?) -> ConsumerType? {
        if let type = typeString {
            return ConsumerType(rawValue: type)
        } else {
            return nil
        }
    }
}

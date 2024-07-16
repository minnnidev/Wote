//
//  VoteListViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/21/23.
//

import Combine
import SwiftUI

final class VoteListViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var error: NetworkError?
    @Published var currentVote = 0
    @Published var posts = [PostModel.init(id: 0,
                                  createDate: "",
                                  modifiedDate: "",
                                  postStatus: "CLOSED",
                                  author: .init(id: 0,
                                                nickname: "닉네임",
                                                profileImage: nil,
                                                consumerType: ConsumerType.ecoWarrior.rawValue,
                                                isBlocked: nil,
                                                isBaned: nil),
                                  title: "테스트")]

    private var cancellables: Set<AnyCancellable> = []
    private var isLastPage = false
    private var page = 0

    private let voteUseCase: VoteUseCaseType

    init(voteUseCase: VoteUseCaseType) {
        self.voteUseCase = voteUseCase
    }

    func fetchPosts(page: Int = 0,
                    size: Int = 5,
                    visibilityScope: VisibilityScopeType,
                    isFirstFetch: Bool = true,
                    isRefresh: Bool = false) {
    }

    func fetchMorePosts(_ visibilityScope: VisibilityScopeType) {

    }

    func votePost(postId: Int,
                  choice: Bool,
                  index: Int) {

    }

    func updatePost(index: Int,
                    myChoice: Bool,
                    voteCount: VoteCountsModel) {
    }

    func calculatVoteRatio(voteCounts: VoteCountsModel?) -> (agree: Double, disagree: Double) {
        guard let voteCounts = voteCounts else { return (0.0, 0.0) }
        let voteCount = voteCounts.agreeCount + voteCounts.disagreeCount
        
        guard voteCount != 0 else { return (0, 0) }
        let agreeRatio = Double(voteCounts.agreeCount) / Double(voteCount) * 100
        return (agreeRatio, 100 - agreeRatio)
    }
}

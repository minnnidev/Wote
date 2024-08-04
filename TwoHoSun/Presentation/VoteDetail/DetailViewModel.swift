//
//  DetailViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/21/23.
//

import Combine
import SwiftUI

final class DetailViewModel: ObservableObject {

    enum Action {
        case loadDetail
        case vote(_ myChoice: Bool)
        case presentSheet
        case presentComment
        case deleteVote
        case closeVote
    }

    @Published var agreeTopConsumerTypes: [ConsumerType]?
    @Published var disagreeTopConsumerTypes: [ConsumerType]?

    @Published var comments: CommentModel?
    @Published var voteDetail: VoteDetailModel?
    @Published var isVoteResultShowed: Bool = false
    @Published var isVoteConsumerTypeResultShowed: Bool = false
    @Published var agreeRatio: Double?
    @Published var disagreeRatio: Double?
    @Published var isMySheetShowed: Bool = false
    @Published var isOtherSheetShowed: Bool = false
    @Published var isVoteManageSucceed: Bool = false
    @Published var isCommentShowed: Bool = false

    let postId: Int
    private let voteUseCase: VoteUseCaseType
    private let userUseCase: UserUseCaseType

    init(
        postId: Int,
        voteUseCase: VoteUseCaseType,
        userUseCase: UserUseCaseType
    ) {
        self.postId = postId
        self.voteUseCase = voteUseCase
        self.userUseCase = userUseCase
    }

    private var cancellables: Set<AnyCancellable> = []

    func send(action: Action) {
        switch action {
        case .loadDetail:
            voteUseCase.loadVoteDetail(postId: postId)
                .sink { completion in
                } receiveValue: { [weak self] voteDetail in
                    self?.voteDetail = voteDetail
                    self?.agreeRatio = voteDetail.post.agreeRatio
                    self?.disagreeRatio = voteDetail.post.disagreeRatio

                    self?.agreeTopConsumerTypes = voteDetail.agreeTopConsumers
                    self?.disagreeTopConsumerTypes = voteDetail.disagreeTopConsumers

                    if voteDetail.post.postStatus == "CLOSED" || voteDetail.post.myChoice != nil {
                        self?.isVoteResultShowed = true
                    }

                    if voteDetail.post.voteCount ?? 0 > 0 { self?.isVoteConsumerTypeResultShowed = true }
                }
                .store(in: &cancellables)

        case let .vote(myChoice):
            voteUseCase.vote(postId: postId, myChoice: myChoice)
                .sink { _ in
                } receiveValue: { [weak self] _ in
                    self?.send(action: .loadDetail)
                }
                .store(in: &cancellables)

        case .presentSheet:
            let isMine = voteDetail?.post.isMine ?? false

            if isMine {
                isMySheetShowed.toggle()
            } else {
                isOtherSheetShowed.toggle()
            }

        case .presentComment:
            isCommentShowed.toggle()

        case .deleteVote:
            voteUseCase.deleteVote(postId: postId)
                .sink { _ in
                } receiveValue: { [weak self] _ in
                    NotificationCenter.default.post(name: .voteDeleted, object: nil)
                    self?.isVoteManageSucceed.toggle()
                }
                .store(in: &cancellables)

        case .closeVote:
            voteUseCase.closeVote(postId: postId)
                .sink { _ in
                } receiveValue: { [weak self] _ in
                    NotificationCenter.default.post(name: .voteClosed, object: nil)
                    self?.send(action: .loadDetail)
                }
                .store(in: &cancellables)
        }
    }
}

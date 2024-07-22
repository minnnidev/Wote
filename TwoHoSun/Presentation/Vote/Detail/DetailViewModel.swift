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
        case deleteVote
        case closeVote
    }

    @Published var agreeTopConsumerTypes: [ConsumerType]?
    @Published var disagreeTopConsumerTypes: [ConsumerType]?

    @Published var comments: CommentsModel?
    @Published var voteDetail: VoteDetailModel?
    @Published var isVoteResultShowed: Bool = false
    @Published var isVoteConsumerTypeResultShowed: Bool = false
    @Published var agreeRatio: Double?
    @Published var disagreeRatio: Double?
    @Published var isMySheetShowed: Bool = false
    @Published var isOtherSheetShowed: Bool = false

    private let postId: Int
    private let voteUseCase: VoteUseCaseType

    init(postId: Int, voteUseCase: VoteUseCaseType) {
        self.postId = postId
        self.voteUseCase = voteUseCase
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

        case .deleteVote:
            voteUseCase.deleteVote(postId: postId)
                .sink { _ in
                } receiveValue: { _ in
                    // TODO: 삭제한 뒤에 처리?
                }
                .store(in: &cancellables)

        case .closeVote:
            return
        }
    }
}

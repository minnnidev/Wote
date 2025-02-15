//
//  ReviewDetailViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/20/23.
//

import Combine
import SwiftUI

final class ReviewDetailViewModel: ObservableObject {

    enum Action {
        case loadDetail
        case deleteReview
        case presentComment
        case presentSheet
        case blockUser(memberId: Int)
    }

    @Published var reviewDetailData: ReviewDetailModel?
    @Published var isLoading: Bool = false
    @Published var isCommentShowed: Bool = false
    @Published var isMySheetShowed: Bool = false
    @Published var isOtherSheetShowed: Bool = false
    @Published var isReviewManageSucceed: Bool = false

    private var cancellables: Set<AnyCancellable> = []

    let id: Int
    private let reviewUseCase: ReviewUseCaseType
    private let userUseCase: UserUseCaseType

    init(
        id: Int,
        reviewUseCase: ReviewUseCaseType,
        userUseCase: UserUseCaseType
    ) {
        self.id = id
        self.reviewUseCase = reviewUseCase
        self.userUseCase = userUseCase
    }

    func send(action: Action) {
        switch action {

        case .loadDetail:
            isLoading = true

            reviewUseCase.loadReviewDetail(reviewId: id)
                .sink { [weak self] _ in
                    self?.isLoading = false
                } receiveValue: { [weak self] detail in
                    self?.reviewDetailData = detail
                    self?.isLoading = false
                }
                .store(in: &cancellables)

        case .deleteReview:
            reviewUseCase.deleteReview(postId: id)
                .sink { _ in
                } receiveValue: { [weak self] _ in
                    self?.isReviewManageSucceed.toggle()
                }
                .store(in: &cancellables)

        case .presentComment:
            isCommentShowed.toggle()

        case .presentSheet:
            let isMine = reviewDetailData?.isMine ?? false

            if isMine {
                isMySheetShowed.toggle()
            } else {
                isOtherSheetShowed.toggle()
            }

        case let .blockUser(memberId):
            userUseCase.blockUser(memberId)
                .sink { _ in
                } receiveValue: { [weak self] _ in
                    self?.isReviewManageSucceed.toggle()
                }
                .store(in: &cancellables)
        }
    }
}

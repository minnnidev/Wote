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
    }

    @Published var reviewDetailData: ReviewDetailModel?
    @Published var isLoading: Bool = false
    @Published var isCommentShowed: Bool = false

    private var cancellables: Set<AnyCancellable> = []

    let id: Int
    private let reviewUseCase: ReviewUseCaseType

    init(id: Int, reviewUseCase: ReviewUseCaseType) {
        self.id = id
        self.reviewUseCase = reviewUseCase
    }

    func send(_ action: Action) {
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
            return

        case .presentComment:
            isCommentShowed.toggle()
        }
    }
}

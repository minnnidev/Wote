//
//  ReviewWriteViewModel.swift
//  TwoHoSun
//
//  Created by 관식 on 11/7/23.
//

import Combine
import Foundation

final class ReviewWriteViewModel: ObservableObject {

    enum Action {
        case selectReviewType(isPurchased: Bool)
        case registerReview
    }

    @Published var isPurchased: Bool = true
    @Published var title: String = ""
    @Published var price: String = ""
    @Published var content: String = ""
    @Published var image: Data?

    @Published var isCreatingReview = false
    @Published var review: ReviewCreateModel?
    @Published var isCompleted = false

    private let reviewUseCase: ReviewUseCaseType
    private let voteId: Int

    init(
        voteId: Int,
        reviewUseCase: ReviewUseCaseType
    ) {
        self.voteId = voteId
        self.reviewUseCase = reviewUseCase
    }

    private var cancellable = Set<AnyCancellable>()

    var isValid: Bool {
        if isPurchased {
            if !title.isEmpty && image != nil {
                return true
            } else {
                return false
            }
        } else {
            if !title.isEmpty {
                return true
            } else {
                return false
            }
        }
    }

    func send(action: Action) {
        switch action {
        case let .selectReviewType(isPurchased):
            self.isPurchased = isPurchased

        case .registerReview:
             // TODO: API 연결
            return
        }
    }
}

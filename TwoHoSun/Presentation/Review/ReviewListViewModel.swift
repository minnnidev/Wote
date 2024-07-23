//
//  ReviewTabViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/19/23.
//

import Combine
import SwiftUI

class PaginationState {
    var currentPage = 1
    var isLastPage = false

    func resetPagination() {
        currentPage = 1
        isLastPage = false
    }
}

final class ReviewListViewModel: ObservableObject {

    enum Action {
        case loadRecentReviews
        case loadReviews
        case loadMoreReviews
    }

    @Published var consumerType: ConsumerType?
    @Published var reviewType: ReviewType = ReviewType.all
    @Published var visibilityScope: VisibilityScopeType = .global
    @Published var recentReviews: [SimpleReviewModel] = []

    private var cancellables: Set<AnyCancellable> = []
    
    private var allTypePagination = PaginationState()
    private var purchasedTypePagination = PaginationState()
    private var notPurchasedTypePagination = PaginationState()

    private let reviewUseCase: ReviewUseCaseType

    init(reviewUseCase: ReviewUseCaseType) {
        self.reviewUseCase = reviewUseCase
    }

    func send(action: Action) {
        switch action {

        case .loadRecentReviews:
            return

        case .loadReviews:
            return

        case .loadMoreReviews:
            return
        }
    }

    func fetchMoreReviews(for visibilityScope: VisibilityScopeType,
                          filter reviewType: ReviewType) {

        var state: PaginationState

        switch reviewType {
        case .all:
            state = allTypePagination
        case .purchased:
            state = purchasedTypePagination
        case .notPurchased:
            state = notPurchasedTypePagination
        }

        guard !state.isLastPage else {
            return
        }
    }
}

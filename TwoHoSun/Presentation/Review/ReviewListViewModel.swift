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
        case loadReviews
        case loadMoreReviews
    }

    @Published var consumerType: ConsumerType?
    @Published var visibilityScope: VisibilityScopeType = .global
    @Published var reviewType: ReviewType = .all {
        didSet {
            updateShowingReviews()
        }
    }

    @Published var recentReviews: [SimpleReviewModel] = []
    @Published var allReviews: [SummaryPostModel] = []
    @Published var purchasedReviews: [SummaryPostModel] = []
    @Published var notPurchasedReviews: [SummaryPostModel] = []
    @Published var showingReviews: [SummaryPostModel] = []
    @Published var isLoading: Bool = false

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

        case .loadReviews:
            isLoading = true

            reviewUseCase.loadReviews(visibilityScope: visibilityScope)
                .sink { [weak self] _ in
                    self?.isLoading = false
                } receiveValue: { [weak self] reviewTabModel in
                    self?.recentReviews = reviewTabModel.recentReviews ?? []
                    
                    self?.showingReviews = reviewTabModel.allReviews
                    self?.allReviews = reviewTabModel.allReviews
                    self?.purchasedReviews = reviewTabModel.purchasedReviews
                    self?.notPurchasedReviews = reviewTabModel.notPurchasedReviews

                    self?.isLoading = true
                }
                .store(in: &cancellables)

        case .loadMoreReviews:
            return
        }
    }

    private func updateShowingReviews() {
        switch reviewType {
        case .all:
            showingReviews = allReviews
        case .purchased:
            showingReviews = purchasedReviews
        case .notPurchased:
            showingReviews = notPurchasedReviews
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

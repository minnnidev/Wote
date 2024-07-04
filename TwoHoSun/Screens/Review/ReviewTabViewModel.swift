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

final class ReviewTabViewModel: ObservableObject {
    
    @Published var consumerType: ConsumerType?
    @Published var isFetching = true
    
    private var cancellable = Set<AnyCancellable>()
    private var allTypePagination = PaginationState()
    private var purchasedTypePagination = PaginationState()
    private var notPurchasedTypePagination = PaginationState()

    func resetReviews() {

    }

    func fetchReviews(for visibilityScope: VisibilityScopeType) {
        isFetching = true
        resetReviews()
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

//
//  ReviewTabViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/19/23.
//

import Combine
import SwiftUI

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
    @Published var allReviews: [ReviewModel] = []
    @Published var purchasedReviews: [ReviewModel] = []
    @Published var notPurchasedReviews: [ReviewModel] = []
    @Published var showingReviews: [ReviewModel] = []
    @Published var isLoading: Bool = false

    private var allpage: Int = 0
    private var purchasedPage: Int = 0
    private var notPurchasedPage: Int = 0
    private var page: Int = 0

    private var cancellables: Set<AnyCancellable> = []

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

                    self?.allpage = 1
                    self?.purchasedPage = 1
                    self?.notPurchasedPage = 1
                }
                .store(in: &cancellables)

        case .loadMoreReviews:
            reviewUseCase.loadMoreReviews(
                visibilityScope: visibilityScope,
                page: page,
                size: 10,
                reviewType: reviewType
            )
            .sink { _ in
            } receiveValue: { [weak self] newReviews in
                guard let self = self else { return }
                switch reviewType {
                case .all:
                    allReviews.append(contentsOf: newReviews)
                    allpage += 1
                case .purchased:
                    purchasedReviews.append(contentsOf: newReviews)
                    purchasedPage += 1
                case .notPurchased:
                    notPurchasedReviews.append(contentsOf: newReviews)
                    notPurchasedPage += 1
                }
            }
            .store(in: &cancellables)
        }
    }

    private func updateShowingReviews() {
        switch reviewType {
        case .all:
            showingReviews = allReviews
            page = allpage
        case .purchased:
            showingReviews = purchasedReviews
            page = purchasedPage
        case .notPurchased:
            showingReviews = notPurchasedReviews
            page = notPurchasedPage
        }
    }
}

//
//  ReviewUseCase.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation
import Combine

protocol ReviewUseCaseType {
    func loadReviews(visibilityScope: VisibilityScopeType) -> AnyPublisher<ReviewTabModel, WoteError>
}

final class ReviewUseCase: ReviewUseCaseType {
    
    private let reviewRepository: ReviewRepositoryType

    init(reviewRepository: ReviewRepositoryType) {
        self.reviewRepository = reviewRepository
    }

    func loadReviews(visibilityScope: VisibilityScopeType) -> AnyPublisher<ReviewTabModel, WoteError> {
        reviewRepository.getReviews(visibilityScope: visibilityScope)
    }
}

final class StubReviewUseCase: ReviewUseCaseType {
    
    func loadReviews(visibilityScope: VisibilityScopeType) -> AnyPublisher<ReviewTabModel, WoteError> {
        Just(ReviewTabModel.reviewTabStub1)
            .setFailureType(to: WoteError.self)
            .eraseToAnyPublisher()
    }
}

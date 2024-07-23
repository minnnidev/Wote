//
//  ReviewRepository.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation
import Combine

final class ReviewRepository: ReviewRepositoryType {

    private let reviewDataSource: ReviewDataSourceType

    init(reviewDataSource: ReviewDataSourceType) {
        self.reviewDataSource = reviewDataSource
    }

    func getReviews(visibilityScope: VisibilityScopeType) -> AnyPublisher<ReviewTabModel, WoteError> {
        reviewDataSource.getReviews(visibilityScope.rawValue)
            .map { $0.toModel() }
            .mapError { WoteError.error($0) }
            .eraseToAnyPublisher()
    }
}

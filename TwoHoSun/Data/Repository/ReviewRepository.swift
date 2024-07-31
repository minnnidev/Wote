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

    func getMoreReviews(
        visibilityScope: VisibilityScopeType,
        page: Int,
        size: Int,
        reviewType: ReviewType
    ) -> AnyPublisher<[ReviewModel], WoteError> {
        let requestObject: MoreReviewRequestObject = .init(
            visibilityScope: visibilityScope.rawValue,
            page: page,
            size: size,
            reviewType: reviewType.rawValue)

        return reviewDataSource.getMoreReviews(requestObject)
            .map { $0.map { $0.toModel()} }
            .mapError { WoteError.error($0) }
            .eraseToAnyPublisher()
    }

    func getReviewDetail(reviewId: Int) -> AnyPublisher<ReviewDetailModel, WoteError> {
        reviewDataSource.getReviewDetail(reviewId)
            .map { $0.toModel() }
            .mapError { WoteError.error($0) }
            .eraseToAnyPublisher()
    }

    func createReview(postId: Int, review: ReviewCreateModel) -> AnyPublisher<Void, WoteError> {
        let requestObject: ReviewCreateRequestObject = .init(
            title: review.title,
            contents: review.contents,
            price: review.price,
            isPurchased: review.isPurchased,
            image: review.image
        )

        return reviewDataSource.createReview(postId: postId, object: requestObject)
            .mapError { WoteError.error($0) }
            .eraseToAnyPublisher()
    }

    func deleteReview(postId: Int) -> AnyPublisher<Void, WoteError> {
        reviewDataSource.deleteReview(postId)
            .mapError { WoteError.error($0) }
            .eraseToAnyPublisher()
    }
}

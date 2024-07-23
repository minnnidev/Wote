//
//  ReviewDataSource.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation
import Combine

protocol ReviewDataSourceType {
    func getReviews(_ visibilityScope: String) -> AnyPublisher<ReviewTabResponseObject, APIError>
    func getMoreReviews(_ object: MoreReviewRequestObject) -> AnyPublisher<[ReviewResponseObject], APIError>
}

final class ReviewDataSource: ReviewDataSourceType {

    typealias Target = ReviewAPI

    private let provider: NetworkProviderType

    init(provider: NetworkProviderType) {
        self.provider = provider
    }

    func getReviews(_ visibilityScope: String) -> AnyPublisher<ReviewTabResponseObject, APIError> {
        provider.requestPublisher(Target.getReviews(visibilityScope: visibilityScope), ReviewTabResponseObject.self)
    }

    func getMoreReviews(_ object: MoreReviewRequestObject) -> AnyPublisher<[ReviewResponseObject], APIError> {
        provider.requestPublisher(Target.getMoreReviews(object), [ReviewResponseObject].self)
    }
}

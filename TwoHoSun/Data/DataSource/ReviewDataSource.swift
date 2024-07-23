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
}

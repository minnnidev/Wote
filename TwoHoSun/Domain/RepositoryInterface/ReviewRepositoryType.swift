//
//  ReviewRepositoryType.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation
import Combine

protocol ReviewRepositoryType {
    func getReviews(visibilityScope: VisibilityScopeType) -> AnyPublisher<ReviewTabModel, WoteError>
}

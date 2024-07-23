//
//  ReviewDetailViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/20/23.
//

import Combine
import SwiftUI

final class ReviewDetailViewModel: ObservableObject {

    enum Action {
        case loadDetail
        case deleteReview
    }

    @Published var reviewData: ReviewDetailModel?

    private let id: Int
    private let reviewUseCase: ReviewUseCaseType

    init(id: Int, reviewUseCase: ReviewUseCaseType) {
        self.id = id
        self.reviewUseCase = reviewUseCase
    }

    func send(_ action: Action) {
        switch action {

        case .loadDetail:
            return

        case .deleteReview:
            return
        }
    }
}

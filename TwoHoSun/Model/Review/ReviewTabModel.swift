//
//  ReviewTabModel.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation

struct ReviewTabModel {
    var recentReviews: [SimpleReviewModel]?
    var allReviews: [ReviewModel]
    var purchasedReviews: [ReviewModel]
    var notPurchasedReviews: [ReviewModel]
}

extension ReviewTabModel {

    static var reviewTabStub1: ReviewTabModel {
        .init(
            recentReviews: [.stub1],
            allReviews: [.reviewStub1],
            purchasedReviews: [.reviewStub1],
            notPurchasedReviews: [.reviewStub1]
        )
    }
}

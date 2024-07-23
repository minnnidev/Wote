//
//  ReviewTabResponseObject.swift
//  TwoHoSun
//
//  Created by 김민 on 11/19/23.
//

import Foundation

struct ReviewTabResponseObject: Codable {
    let myConsumerType: String?
    var recentReviews: [SummaryPostResponseObject]?
    var allReviews: [SummaryPostResponseObject]
    var purchasedReviews: [SummaryPostResponseObject]
    var notPurchasedReviews: [SummaryPostResponseObject]
}

extension ReviewTabResponseObject {

    func toModel() -> ReviewTabModel {
        .init(
            recentReviews: recentReviews?.map { $0.toSimpleModel() },
            allReviews: allReviews.map { $0.toModel() },
            purchasedReviews: purchasedReviews.map { $0.toModel() },
            notPurchasedReviews: notPurchasedReviews.map { $0.toModel() }
        )
    }
}

enum ReviewType: String, CaseIterable {
    case all = "ALL"
    case purchased = "PURCHASED"
    case notPurchased = "NOT_PURCHASED"

    var title: String {
        switch self {
        case .all:
            return "모두"
        case .purchased:
            return "샀다"
        case .notPurchased:
            return "안샀다"
        }
    }
}

//
//  MyReviewsReponseObject.swift
//  TwoHoSun
//
//  Created by 김민 on 7/29/24.
//

import Foundation

struct MyReviewsReponseObject: Codable {
    let total: Int
    let posts: [ReviewResponseObject]
}

extension MyReviewsReponseObject {
    
    func toModel() -> MyReviewsModel {
        .init(
            total: total,
            myReviews: posts.map { $0.toModel() }
        )
    }
}

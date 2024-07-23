//
//  SummaryPostResponseObject.swift
//  TwoHoSun
//
//  Created by 관식 on 11/17/23.
//

import Foundation

struct ReviewResponseObject: Codable, Identifiable {
    var id: Int
    var createDate: String
    var modifiedDate: String
    var author: AuthorResponseObject?
    var postStatus: String
    var viewCount: Int?
    var voteCount: Int?
    var commentCount: Int?
    var voteResult: String?
    var title: String
    var image: String?
    var contents: String?
    var price: Int?
    var isPurchased: Bool?
    var hasReview: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "postId"
        case createDate, modifiedDate, author, postStatus, viewCount, 
             voteCount, commentCount, voteResult, title, image, contents,
             price, isPurchased, hasReview
    }
}

extension ReviewResponseObject {

    func toSimpleModel() -> SimpleReviewModel {
        .init(
            id: id,
            isPurchased: isPurchased ?? false,
            title: title,
            content: contents ?? ""
        )
    }

    func toModel() -> ReviewModel {
        .init(
            id: id,
            createDate: createDate,
            modifiedDate: modifiedDate,
            author: author?.toModel(),
            postStatus: postStatus,
            title: title,
            image: image,
            contents: contents,
            price: price,
            isPurchased: isPurchased
        )
    }
}

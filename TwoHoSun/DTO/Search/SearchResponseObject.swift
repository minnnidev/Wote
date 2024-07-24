//
//  SearchResponseObject.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation

struct SearchResponseObject: Codable {
    var id: Int
    var createDate: String
    var modifiedDate: String
    var postStatus: String
    var author: AuthorResponseObject
    var title: String
    var contents: String?
    var image: String?
    var voteCount: Int?
    var commentCount: Int?
    var price: Int?
    var voteResult: String?
    var isPurchased: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "postId"
        case createDate, modifiedDate, postStatus, author, title, contents, image, voteCount, commentCount, price, isPurchased
    }
}

extension SearchResponseObject {

    func toVoteModel() -> VoteModel {
        .init(
            id: id,
            createDate: createDate,
            modifiedDate: modifiedDate,
            postStatus: postStatus,
            author: author.toModel(),
            title: title,
            contents: contents,
            image: image,
            price: price,
            voteResult: voteResult
        )
    }

    func toReviewModel() -> ReviewModel {
        .init(
            id: id,
            createDate: createDate,
            modifiedDate: modifiedDate,
            author: author.toModel(),
            postStatus: postStatus,
            title: title,
            image: image,
            contents: contents,
            price: price,
            isPurchased: isPurchased
        )
    }
}

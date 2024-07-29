//
//  MyVotesResponseObject.swift
//  TwoHoSun
//
//  Created by 김민 on 7/29/24.
//

import Foundation

struct MyVotesResponseObject: Codable {
    let total: Int
    let posts: [MyVoteResponseObject]
}

extension MyVotesResponseObject {

    func toModel() -> MyVotesModel {
        .init(
            total: total,
            votes: posts.map { $0.toModel() }
        )
    }
}

struct MyVoteResponseObject: Codable {
    var id: Int
    var createDate: String
    var modifiedDate: String
    var visibilityScope: String?
    var postStatus: String
    var title: String
    var contents: String?
    var image: String?
    var price: Int?
    var voteResult: String?
    var hasReview: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "postId"
        case createDate, modifiedDate, visibilityScope, postStatus, title, contents, image, price, voteResult, hasReview
    }
}

extension MyVoteResponseObject {

    func toModel() -> MyVoteModel {
        .init(
            id: id,
            createDate: createDate,
            modifiedDate: modifiedDate,
            visibilityScope: visibilityScope,
            postStatus: postStatus,
            title: title,
            contents: contents,
            image: image,
            price: price,
            voteResult: voteResult,
            hasReview: hasReview
        )
    }
}

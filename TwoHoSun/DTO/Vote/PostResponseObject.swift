//
//  PostResponseObject.swift
//  TwoHoSun
//
//  Created by 김민 on 7/16/24.
//

import Foundation

struct PostResponseObject: Codable, Identifiable {
    var id: Int
    var createDate: String
    var modifiedDate: String
    var visibilityScope: String?
    var postStatus: String
    var author: AuthorResponseObject
    var title: String
    var contents: String?
    var image: String?
    var externalURL: String?
    var voteCount: Int?
    var commentCount: Int?
    var price: Int?
    var myChoice: Bool?
    var voteCounts: VoteCountsResponseObject?
    var voteInfoList: [VoteInfoResponseObject]?
    var isMine: Bool?
    var isNotified: Bool?
    var isPurchased: Bool?
    var hasReview: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "postId"
        case createDate, modifiedDate, visibilityScope,
             postStatus, author, title, contents, image,
             externalURL, voteCount, commentCount, price,
             myChoice, voteCounts, isMine, isNotified, isPurchased, hasReview, voteInfoList
    }
}

extension PostResponseObject {

    func toModel() -> VoteModel {
        .init(
            id: id,
            createDate: createDate,
            modifiedDate: modifiedDate,
            visibilityScope: visibilityScope,
            postStatus: postStatus,
            author: author.toModel(),
            title: title,
            contents: contents,
            image: image,
            externalURL: externalURL,
            voteCount: voteCount,
            commentCount: commentCount,
            price: price,
            voteCounts: voteCounts?.toModel(),
            voteInfoList: voteInfoList.map { $0.map { $0.toModel() }},
            myChoice: myChoice
        )
    }
}

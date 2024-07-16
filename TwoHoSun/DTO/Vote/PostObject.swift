//
//  PostObject.swift
//  TwoHoSun
//
//  Created by 김민 on 7/16/24.
//

import Foundation

struct PostObject: Codable, Identifiable {
    var id: Int
    var createDate: String
    var modifiedDate: String
    var visibilityScope: String?
    var postStatus: String
    var author: AuthorModel
    var title: String
    var contents: String?
    var image: String?
    var externalURL: String?
    var voteCount: Int?
    var commentCount: Int?
    var price: Int?
    var myChoice: Bool?
    var voteCounts: VoteCountsObject?
    var voteInfoList: [VoteInfoObject]?
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

//
//  SummaryPostModel.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation

struct SummaryPostModel: Identifiable {
    var id: Int
    var createDate: String
    var modifiedDate: String
    var author: AuthorModel?
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

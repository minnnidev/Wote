//
//  MyVotesModel.swift
//  TwoHoSun
//
//  Created by 김민 on 7/29/24.
//

import Foundation

struct MyVotesModel {
    let total: Int
    let votes: [MyVoteModel]
}

struct MyVoteModel {
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

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

extension MyVoteModel {

    static var myVoteStub: MyVoteModel {
        .init(
            id: 1,
            createDate: "2024-07-25T01:58:07.347461",
            modifiedDate: "2024-07-25T01:58:07.347461",
            visibilityScope: "GLOBAL",
            postStatus: "CLOSED",
            title: "테스트",
            contents: "content 테스트입니다 테스트입니다",
            image: "https://www.wote.social/images/posts/78ec4f86-5676-4c70-ae16-0334c452ec72.jpg",
            price: 3000,
            voteResult: "BUY",
            hasReview: false
        )
    }
}

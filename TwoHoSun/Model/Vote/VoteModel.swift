//
//  VoteModel.swift
//  TwoHoSun
//
//  Created by 김민 on 7/16/24.
//

import Foundation

struct VoteModel: Identifiable {
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
    var voteCounts: VoteCountsModel?
    var voteInfoList: [VoteInfoModel]?
    var myChoice: Bool?
    var isMine: Bool?
    var hasReview: Bool?
}

extension VoteModel {

    static var voteStub1: VoteModel {
        .init(
            id: 1,
            createDate: "2024-07-15T15:58:19.527938",
            modifiedDate: "2024-07-16T15:58:19.933483",
            visibilityScope: "GLOBAL", 
            postStatus: "ACTIVE",
            author: AuthorModel.authorStub1,
            title: "투표1",
            voteCount: 100,
            commentCount: 5,
            price: 1000,
            voteCounts: VoteCountsModel.voteCountsStub1,
            voteInfoList: VoteInfoModel.voteInfoStub1,
            myChoice: nil,
            isMine: true
        )
    }

    static var voteStub2: VoteModel {
        .init(
            id: 2,
            createDate: "2024-07-15T15:58:19.527938",
            modifiedDate: "2024-07-16T15:58:19.933483",
            visibilityScope: "GLOBAL", 
            postStatus: "CLOSED",
            author: AuthorModel.authorStub1,
            title: "투표1",
            voteCount: 100,
            commentCount: 5,
            price: 1000,
            voteCounts: VoteCountsModel.voteCountsStub1,
            voteInfoList: VoteInfoModel.voteInfoStub1,
            myChoice: nil,
            isMine: false
        )
    }
}

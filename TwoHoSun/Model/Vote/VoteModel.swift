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
    var agreeRatio: Double?
    var disagreeRatio: Double?
}

extension VoteModel {

    init(post: VoteModel, agreeRatio: Double?, disagreeRatio: Double?) {
        self.id = post.id
        self.createDate = post.createDate
        self.modifiedDate = post.modifiedDate
        self.visibilityScope = post.visibilityScope
        self.postStatus = post.postStatus
        self.author = post.author
        self.title = post.title
        self.contents = post.contents
        self.image = post.image
        self.externalURL = post.externalURL
        self.voteCount = post.voteCount
        self.commentCount = post.commentCount
        self.price = post.price
        self.voteCounts = post.voteCounts
        self.voteInfoList = post.voteInfoList
        self.myChoice = post.myChoice
        self.isMine = post.isMine
        self.hasReview = post.hasReview
        self.agreeRatio = agreeRatio
        self.disagreeRatio = disagreeRatio
    }

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
            isMine: true,
            agreeRatio: 0.3,
            disagreeRatio: 0.7
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
            isMine: false,
            agreeRatio: 0.5,
            disagreeRatio: 0.5
        )
    }
}

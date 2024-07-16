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
}

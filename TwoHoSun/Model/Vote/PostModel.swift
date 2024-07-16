//
//  PostResponseDto.swift
//  TwoHoSun
//
//  Created by 김민 on 10/20/23.
//

import Foundation

// TODO: - 연관된 모델 정리 후 Codable 삭제



struct PostModel: Codable, Identifiable {
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
    var voteCounts: VoteCountsModel?
    var voteInfoList: [VoteInfoModel]?
    var isMine: Bool?
    var isNotified: Bool?
    var isPurchased: Bool?
    var hasReview: Bool?
}

struct AuthorModel: Codable, Hashable {
    let id: Int
    let nickname: String
    let profileImage: String?
    let consumerType: String
    let isBlocked: Bool?
    let isBaned: Bool?
}
struct VoteInfoModel: Codable {
    let isAgree: Bool
    let consumerType: String
}

struct VoteCountsModel: Codable {
    let agreeCount: Int
    let disagreeCount: Int
}

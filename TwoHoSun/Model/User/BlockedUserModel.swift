//
//  BlockedUserModel.swift
//  TwoHoSun
//
//  Created by 관식 on 11/24/23.
//

import Foundation

struct BlockedUserModel {
    var id: Int
    var nickname: String
}

extension BlockedUserModel {

    static var stubBlockedUser1: BlockedUserModel {
        .init(id: 0, nickname: "차단당한 유저1")
    }
}

//
//  BlockUserResponse.swift
//  TwoHoSun
//
//  Created by 김민 on 8/4/24.
//

import Foundation

struct BlockedUserResponse: Codable {
    let id: Int
    let nickname: String
}

extension BlockedUserResponse {

    func toModel() -> BlockedUserModel {
        .init(id: id, nickname: nickname)
    }
}

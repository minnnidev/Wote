//
//  VoteRequestObject.swift
//  TwoHoSun
//
//  Created by 김민 on 7/16/24.
//

import Foundation

struct VoteRequestObject: Codable {
    let page: Int
    let size: Int
    let visibilityScope: String
}

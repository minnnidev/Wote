//
//  MyVotesRequestObject.swift
//  TwoHoSun
//
//  Created by 김민 on 7/29/24.
//

import Foundation

struct MyVotesRequestObject: Codable {
    let page: Int
    let size: Int
    var myVoteCategoryType: String = "ALL_VOTES"
}

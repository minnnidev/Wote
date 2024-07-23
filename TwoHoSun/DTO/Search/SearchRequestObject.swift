//
//  SearchRequestObject.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation

struct SearchRequestObject: Codable {
    let postStatus: String
    let visibilityScope: String
    let page: Int
    let size: Int
    let keyword: String
}

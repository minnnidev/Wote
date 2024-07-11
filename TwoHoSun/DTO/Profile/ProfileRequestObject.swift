//
//  ProfileRequestObject.swift
//  TwoHoSun
//
//  Created by 김민 on 7/10/24.
//

import Foundation

struct ProfileRequestObject: Codable {
    let imageFile: Data?
    let nickname: String
    let school: SchoolObject? 
}

struct SchoolObject: Codable {
    let schoolName: String
    let schoolRegion: String
}

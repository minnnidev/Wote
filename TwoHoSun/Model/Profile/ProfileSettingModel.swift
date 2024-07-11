//
//  ProfileSettingModel.swift
//  TwoHoSun
//
//  Created by 관식 on 10/18/23.
//

import SwiftUI

struct ProfileSettingModel: Codable {
    var imageFile: Data?
    var nickname: String
    var school: SchoolModel?
}

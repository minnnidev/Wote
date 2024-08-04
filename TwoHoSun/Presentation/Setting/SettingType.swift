//
//  SettingType.swift
//  TwoHoSun
//
//  Created by 김민 on 8/4/24.
//

import SwiftUI

enum SettingType {
    case notification
    case block
    case announcement
    case questions
    case terms
    case appVersion
    case logOut

    var label: String {
        switch self {
        case .notification:
            "알림"
        case .block:
            "차단 목록"
        case .announcement:
            "공지사항"
        case .questions:
            "문의사항"
        case .terms:
            "이용약관"
        case .appVersion:
            "앱 버전"
        case .logOut:
            "로그아웃"
        }
    }

    var icon: String {
        switch self {
        case .notification:
            "bell"
        case .block:
            "person.crop.circle"
        case .announcement:
            "megaphone"
        case .questions:
            "questionmark"
        case .terms:
            "doc.plaintext"
        case .appVersion:
            "doc.plaintext"
        case .logOut:
            "minus"
        }
    }

    var color: Color {
        switch self {
        case .notification:
            Color.settingYellow
        case .block:
            Color.settingRed
        case .announcement:
            Color.settingRed
        case .questions:
            Color.settingBlue
        case .terms:
            Color.settingGray
        case .appVersion:
            Color.settingGray
        case .logOut:
            Color.settingGray
        }
    }
}

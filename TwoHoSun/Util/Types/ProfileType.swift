//
//  NicknameValidationType.swift
//  TwoHoSun
//
//  Created by 김민 on 7/10/24.
//

import Foundation
import SwiftUI

enum NicknameValidationType {
    case none, empty, length, forbiddenWord, duplicated, valid, same

    var alertMessage: String {
        switch self {
        case .none:
            return ""
        case .empty:
            return "닉네임을 입력해주세요."
        case .length:
            return "닉네임은 1~10자로 설정해주세요."
        case .forbiddenWord:
            return "해당 닉네임으로는 아이디를 생성할 수 없어요."
        case .duplicated:
            return "중복된 닉네임입니다."
        case .valid:
            return "사용 가능한 닉네임입니다."
        case .same:
            return "같은 닉네임입니다."
        }
    }

    var alertMessageColor: Color {
        switch self {
        case .none:
            return .clear
        case .valid:
            return Color.deepBlue
        default:
            return Color.errorRed
        }
    }

    var textfieldBorderColor: Color {
        switch self {
        case .none, .valid:
            return Color.grayStroke
        default:
            return Color.errorRed
        }
    }
}

enum ProfileInputType {
    case nickname, school

    var iconName: String {
        switch self {
        case .nickname:
            return ""
        case .school:
            return "magnifyingglass"
        }
    }

    var placeholder: String {
        switch self {
        case .nickname:
            return "한/영 10자 이내(특수문자 불가)"
        case .school:
            return "학교를 검색해주세요."
        }
    }

    var alertMessage: String {
        switch self {
        case .nickname:
            return "닉네임을 입력해주세요."
        case .school:
            return "학교를 입력해주세요."
        }
    }
}

//
//  SettingViewModel.swift
//  TwoHoSun
//
//  Created by 관식 on 11/22/23.
//

import Combine
import SwiftUI

class SettingViewModel: ObservableObject {

    var blockUsersList: [BlockUserModel] = []

    private var cancellable = Set<AnyCancellable>()

    func requestLogOut() {
        // TODO: logout
    }
    
    func deleteUser() {
        // TODO: 탈퇴
    }
    
    func getBlockUsers() {
        // TODO: 차단 목록 조회
    }
    
    func deleteBlockUser(memberId: Int) {
        // TODO: 차단 해제
    }
}

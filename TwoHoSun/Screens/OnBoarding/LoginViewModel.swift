//
//  LoginViewModel.swift
//  TwoHoSun
//
//  Created by 235 on 10/16/23.
//

import SwiftUI

import Alamofire
import Combine
import Moya

class LoginViewModel: ObservableObject {
    var showSheet = false
    var authorization: String = ""

    private var bag = Set<AnyCancellable>()

    func setAuthorizationCode(_ code: String) {
        self.authorization = code
    }
}

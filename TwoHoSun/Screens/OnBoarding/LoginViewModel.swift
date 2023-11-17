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

@Observable
class LoginViewModel {
    var showSheet = false
    var authorization: String = ""
    var goMain = false
    private var bag = Set<AnyCancellable>()
    private var appState: AppLoginState

    init(appState: AppLoginState) {
        self.appState = appState
    }

    func setAuthorizationCode(_ code: String) {
        self.authorization = code
    }

    func postAuthorCode() {
        appState.serviceRoot.apimanager
            .requestLogin(authorization: authorization)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let failure):
                    print(failure)
                }
            }, receiveValue: { response in
                if let data = response.data {
                    self.appState.serviceRoot.auth.saveTokens(data.jwtToken)
                    if response.message == "Not Completed SignUp Exception" {
                        UserDefaults.standard.setValue(false, forKey: "haveConsumerType")
                        self.appState.serviceRoot.auth.authState = .unfinishRegister
                        self.showSheet = true
                    } else {
                        UserDefaults.standard.setValue(data.consumerTypeExist, forKey: "haveConsumerType")
                        self.appState.serviceRoot.auth.authState = .loggedIn
                        self.goMain = true
                    }
                }
            })
            .store(in: &bag)
    }
}

//
//  TwoHoSunApp.swift
//  TwoHoSun
//
//  Created by 관식 on 10/15/23.
//

import Combine
import SwiftUI
import Observation

@main
struct TwoHoSunApp: App {
    @StateObject private var appState = AppLoginState()
    
    @StateObject private var appDependency = AppDependency()
    @StateObject private var navigationRouter = NavigationRouter()
    

    var body: some Scene {
        WindowGroup {
            OnboardingView()
                .environmentObject(appDependency)
                .environmentObject(navigationRouter)
        }
    }

}

class ServiceRoot {
    var auth = Authenticator()
    lazy var apimanager: NewApiManager = {
        let manager = NewApiManager(authenticator: auth)
        return manager
    }()
    var navigationManager = NavigationRouter()
    lazy var memberManager = MemberManager(authenticator: auth)
}


class AppData: ObservableObject {

}

class AppLoginState: ObservableObject {
    var serviceRoot: ServiceRoot
    var appData: AppData

    init() {
        appData = AppData()
        serviceRoot = ServiceRoot()
        checkTokenValidity()
        serviceRoot.auth.relogin = relogin
        serviceRoot.memberManager.fetchProfile()
    }

    private func relogin() {
        DispatchQueue.main.async {
            self.serviceRoot.auth.authState = .none
        }
    }

    private func checkTokenValidity() {
        if serviceRoot.apimanager.authenticator.accessToken != nil {
            serviceRoot.auth.authState = .loggedIn
        } else {
            serviceRoot.auth.authState = .none
        }
    }
}

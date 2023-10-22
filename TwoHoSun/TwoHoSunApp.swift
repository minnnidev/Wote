//
//  TwoHoSunApp.swift
//  TwoHoSun
//
//  Created by 관식 on 10/15/23.
//

import SwiftUI
import Observation

@main
struct TwoHoSunApp: App {
    let appState = AppState()
    @ObservedObject var viewModel = LoginViewModel()

    var body: some Scene {
        WindowGroup {
//            if appState.hasValidToken {
//             MainView()
//            } else {
//            OnBoardingView()
//            }
//
//            MainTabView()
//            MainView()
//            NavigationView {
//                WriteView(isWriteViewPresented: .constant(true), viewModel: WriteViewModel())
//            }
            ProfileSettingsView(navigationPath: $viewModel.navigationPath,
                                viewModel: ProfileSettingViewModel())
        }
    }
}

@Observable
class AppState {
    var hasValidToken: Bool = false
    
    init() {
        checkTokenValidity()
    }
    
    private func checkTokenValidity() {
        if KeychainManager.shared.readToken(key: "accessToken") != nil {
            hasValidToken = true
        } else {
            hasValidToken = false
        }
    }
}

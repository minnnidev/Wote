//
//  TwoHoSunApp.swift
//  TwoHoSun
//
//  Created by 관식 on 10/15/23.
//

import SwiftUI

@main
struct TwoHoSunApp: App {
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    @StateObject private var appDependency = AppDependency()

    var body: some Scene {
        WindowGroup {
            OnboardingView()
                .environmentObject(appDependency)
        }
    }
}

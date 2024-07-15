//
//  OnboardingView.swift
//  TwoHoSun
//
//  Created by 김민 on 7/9/24.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var appDependency: AppDependency

    @AppStorage(AppStorageKey.loginState) private var isLoggedIn: Bool = false

    var body: some View {
        Group {
            if isLoggedIn {
                WoteTabView()
            } else {
                LoginView(viewModel: appDependency.container.resolve(LoginViewModel.self)!)
            }
        }
        .onAppear {
            isLoggedIn = false
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppDependency())
}

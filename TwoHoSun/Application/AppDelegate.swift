//
//  AppDelegate.swift
//  TwoHoSun
//
//  Created by 김민 on 8/5/24.
//

import UIKit

import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate {
    var app: TwoHoSunApp?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.badge, .sound, .alert]) { granted, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Noti Granted")
            }
        }
        application.registerForRemoteNotifications()
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceString =  deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        KeychainManager.shared.save(key: TokenType.deviceToken, token: deviceString)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate { }

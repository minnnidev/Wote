//
//  AppDelegate.swift
//  TwoHoSun
//
//  Created by HyunwooPark on 10/29/23.
//

import UIKit
import UserNotifications
import os.log

class AppDelegate: UIResponder, UIApplicationDelegate {
    var app: TwoHoSunApp?
    let logger = Logger(subsystem: "com.twohosun.TwoHoSun", category: "PushNotifications")

    func application(_ application: UIApplication, 
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        removeKeychainAtFirstLaunch()
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.badge, .sound, .alert]) { granted, error in
            if let error = error {
                self.logger.error("Authorization request failed: \(error.localizedDescription)")
            } else {
                self.logger.log("Authorization granted: \(granted)")
            }
        }
        application.registerForRemoteNotifications()
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        logger.log("Registered for remote notifications with device token: \(deviceToken.map { String(format: "%02.2hhx", $0) }.joined())")
        let deviceString =  deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        KeychainManager.shared.saveToken(key: "deviceToken", token: deviceString)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        logger.error("Failed to register for remote notifications: \(error.localizedDescription)")
    }

    private func formatDictionary(_ dictionary: [AnyHashable: Any]?) -> String {
        guard let dictionary = dictionary else { return "None" }
        return dictionary.map { key, value in
            "\(key): \(self.decodeUnicodeStringIfNeeded(String(describing: value)))"
        }.joined(separator: ", ")
    }

    private func decodeUnicodeStringIfNeeded(_ string: String) -> String {
        // 유니코드 이스케이프 시퀀스를 정상적인 문자열로 디코딩
        if let data = string.data(using: .utf8),
           let decodedString = String(data: data, encoding: .nonLossyASCII) {
            return decodedString
        } else {
            return string
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        if let consumerType = userInfo["consumer_type_exist"] {
             UserDefaults.standard.setValue(consumerType, forKey: "haveConsumerType")
        }
        return .newData
    }

    private func removeKeychainAtFirstLaunch() {
          guard UserDefaults.isFirstLaunch() else {
              return
          }
        KeychainManager.shared.deleteToken(key: "accessToken")
        KeychainManager.shared.deleteToken(key: "refreshToken")
      }
}

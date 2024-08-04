//
//  NotificationCenter+.swift
//  TwoHoSun
//
//  Created by 김민 on 7/22/24.
//

import Foundation

extension Notification.Name {

    static let voteDeleted = Notification.Name(rawValue: "VoteDeleted")
    static let voteClosed = Notification.Name(rawValue: "VoteClosed")
    static let reviewDeleted = Notification.Name(rawValue: "ReviewDeleted")
    static let userBlocked = Notification.Name(rawValue: "UserBlocked")
}

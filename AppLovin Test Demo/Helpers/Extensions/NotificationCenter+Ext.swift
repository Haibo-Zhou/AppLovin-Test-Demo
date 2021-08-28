//
//  NotificationCenter+Ext.swift
//  AppLovin Test Demo
//
//  Created by HaiboZhou on 2021/8/28.
//

import Foundation

extension Notification.Name {
    
    // Notify user when delegate method `didRewardUser` has returned the valid reward
    static var sendRewardToUser: Notification.Name {
        return .init(rawValue: #function)
    }
}

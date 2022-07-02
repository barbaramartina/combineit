//
//  View+Notifications.swift
//  CombineIt
//
//  Created by Barbara Rodeker on 2022-05-24.
//

import SwiftUI

extension View {
  
    func onAppEnteredBackground(perform action: @escaping () -> Void) -> some View {
        onReceive(NotificationCenter.default.publisher(
            for: UIApplication.didEnterBackgroundNotification
        )) { _ in
            action()
        }
    }

    func onReceiveMemoryWarning(perform action: @escaping () -> Void) -> some View {
        onReceive(NotificationCenter.default.publisher(
            for: UIApplication.didReceiveMemoryWarningNotification
        )) { _ in
            action()
        }
    }

    func onScreenshotTaken(perform action: @escaping () -> Void) -> some View {
        onReceive(NotificationCenter.default.publisher(
            for: UIApplication.userDidTakeScreenshotNotification
        )) { _ in
            action()
        }
    }

    func onAppWillEnterForeground(perform action: @escaping () -> Void) -> some View {
        onReceive(NotificationCenter.default.publisher(
            for: UIApplication.willEnterForegroundNotification
        )) { _ in
            action()
        }
    }

}


//
//  NotificationsView.swift
//  CombineIt
//
//  Created by Barbara Rodeker on 2022-05-23.
//

import SwiftUI

/// You can receive notifications as a combine publisher, as an alternative
/// to the traditional asynchronous events with list and post for notifications
struct NotificationsView: View {
    
    @State private var backgroundCount = 0
    @State private var foregroundCount = 0
    @State private var screenshotsCount = 0


    var body: some View {
        ZStack {
            Color("LightBraun")
                .ignoresSafeArea()
            
            ScrollView {
                
                DocumentationLinkView(link: "https://developer.apple.com/documentation/foundation/notificationcenter/3329353-publisher")
                
                Text("Background")
                    .font(.largeTitle)
                Text("Going to background \(backgroundCount) times")
                    .padding(.bottom, 16)
                Text("Foreground")
                    .font(.largeTitle)
                Text("Going to foreground \(foregroundCount) times")
                    .padding(.bottom, 16)
                Text("Screenshots")
                    .font(.largeTitle)
                Text("Going to background \(screenshotsCount) times")
                    .padding(.bottom, 16)
            }
        }
        // You can attach to notifications publishers directly on onReceive - the cancellation is managed by SwiftUI
        .onReceive(NotificationCenter.default.publisher(
            for: UIApplication.didEnterBackgroundNotification
        )) { _ in
            backgroundCount += 1
        }
        .onAppWillEnterForeground {
            foregroundCount += 1
        }
        .onScreenshotTaken {
            screenshotsCount += 1
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}



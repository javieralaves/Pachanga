//
//  PachangaApp.swift
//  Pachanga
//
//  Created by Javier Alaves on 28/6/23.
//

import Firebase
import FirebaseMessaging
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Pachanga application is starting up. ApplicationDelegate didFinishLaunchingWithOptions.")
        FirebaseApp.configure()
        requestPushNotificationsAuth(application: application)
        return true
    }
    
    // handles how notifications will be presented
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    // handles receiving notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    // generate request for push notifications
    private func requestPushNotificationsAuth(application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
        application.registerForRemoteNotifications()
    }
    
    // assign device token to firebase cloud messaging service
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
}

@main
struct PachangaApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainView()
            }
        }
    }
}

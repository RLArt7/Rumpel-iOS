//
//  AppDelegate.swift
//  Rumpel
//
//  Created by Harel Avikasis on 25/06/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging

let kNotificationsToken: String = "deviceNotificationsToken"
let kPushNotificationsIsOn: String = "isPushNotificationsOn"
let kIsFirstTimeKey: String  = "isFirstTimeKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var sleepDate : TimeInterval?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        application.applicationIconBadgeNumber = 0
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        
        UserManager.manager.fetchUserFromDefaults()
        
        if LoginManager.manager.currnetUser() != nil && UserManager.manager.name != ""
        {
            FirebaseManager.manager.fetchUserChatHistoryMap(completion: { (Bool) in
                
                if UserDefaults.standard.bool(forKey: kPushNotificationsIsOn) || !UserDefaults.standard.bool(forKey: kIsFirstTimeKey)
                {
                    self.registerPushNotifications(application: application)
                }
            })
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navController = storyboard.instantiateViewController(withIdentifier :"navigationController") as! UINavigationController
            navController.modalPresentationStyle = .overFullScreen
            self.window?.rootViewController = navController
            self.window?.makeKeyAndVisible()
        }
        else
        {
            self.registerPushNotifications(application: application)
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification(notification:)),
                                               name: NSNotification.Name.InstanceIDTokenRefresh,
                                               object: nil)
        return true
    }
    
    func returnToLoginPage()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier :"LoginViewController") as! LoginViewController
        vc.modalPresentationStyle = .overFullScreen
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                            open: url,
                                                                            sourceApplication: sourceApplication!,
                                                                            annotation: annotation)
        
        return handled
    }
    
    func checkFor5MinInBackground()
    {
        let timeToRefresh = 3600
        
        if (Date.timeIntervalSinceReferenceDate - self.sleepDate!) > TimeInterval(timeToRefresh)
        {
            forceAppRefresh()
        }
    }
    
    func forceAppRefresh()
    {
        if let vc = window?.rootViewController as? UINavigationController
        {
            vc.popToRootViewController(animated: false)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        self.sleepDate = Date.timeIntervalSinceReferenceDate
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        checkFor5MinInBackground()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
//  MARK: Push Notifications
    func registerPushNotifications(application: UIApplication)
    {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        let deviceTokenString = String(format: "%@", deviceToken as CVarArg)
            .trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
            .replacingOccurrences(of: " ", with: "")
        Messaging.messaging()
            .setAPNSToken(deviceToken, type: MessagingAPNSTokenType.unknown)
        
        if UserDefaults.standard.bool(forKey: kPushNotificationsIsOn) || !UserDefaults.standard.bool(forKey: kIsFirstTimeKey)
        {
            UserDefaults.standard.set(true, forKey: kIsFirstTimeKey)

            if let refreshedToken = InstanceID.instanceID().token() {
                print("InstanceID token: \(refreshedToken)")
                UserManager.manager.userToken = refreshedToken
                FirebaseManager.manager.updateUserToken(completion: { (bool) in
                    print(bool)
                })
            }
            let userDefaults = UserDefaults.standard
            userDefaults.set(deviceTokenString , forKey: kNotificationsToken)
            userDefaults.set(true , forKey: kPushNotificationsIsOn)
        }
        
    }
    
    //  MARK: FireBase Push notifications
    func tokenRefreshNotification(notification: NSNotification)
    {
        if UserDefaults.standard.bool(forKey: kPushNotificationsIsOn)
        {
            if let refreshedToken = InstanceID.instanceID().token() {
                print("InstanceID token: \(refreshedToken)")
                UserManager.manager.userToken = refreshedToken
                FirebaseManager.manager.updateUserToken(completion: { (bool) in
                    print(bool)
                })
            }
        }
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    func connectToFcm()
    {
        Messaging.messaging().shouldEstablishDirectChannel = true
        print("connecting to from FCM.")
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        if userInfo[gcmMessageIDKey] != nil {
            // print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if userInfo[gcmMessageIDKey] != nil {
            // print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String)
    {
        UserManager.manager.userToken = fcmToken
    }
}


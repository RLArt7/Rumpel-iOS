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
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if UserDefaults.standard.bool(forKey: kPushNotificationsIsOn) || !UserDefaults.standard.bool(forKey: kIsFirstTimeKey)
        {
            UserDefaults.standard.set(true, forKey: kIsFirstTimeKey)
            registerPushNotifications(application: application)
        }
        
        FirebaseApp.configure()
       
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        
        if LoginManager.manager.currnetUser() != nil
        {
            UserManager.manager.fetchUserFromDefaults()
            FirebaseManager.manager.fetchUserChatHistoryMap(completion: { (Bool) in
               
            })
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navController = storyboard.instantiateViewController(withIdentifier :"navigationController") as! UINavigationController
            navController.modalPresentationStyle = .overFullScreen
            self.window?.rootViewController = navController
            self.window?.makeKeyAndVisible()
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification(notification:)),
                                               name: NSNotification.Name.InstanceIDTokenRefresh,
                                               object: nil)
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                            open: url,
                                                                            sourceApplication: sourceApplication!,
                                                                            annotation: annotation)
        
        return handled
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
            Messaging.messaging().remoteMessageDelegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        
        
        //          AppsFlyerTracker.shared().registerUninstall(deviceToken)
        let deviceTokenString = String(format: "%@", deviceToken as CVarArg)
            .trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
            .replacingOccurrences(of: " ", with: "")
        
        InstanceID.instanceID().setAPNSToken(deviceToken, type: InstanceIDAPNSTokenType.prod)
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(deviceTokenString , forKey: kNotificationsToken)
    }
    
    //  MARK: FireBase Push notifications
    func tokenRefreshNotification(notification: NSNotification)
    {
        if UserDefaults.standard.bool(forKey: kPushNotificationsIsOn) || !UserDefaults.standard.bool(forKey: kIsFirstTimeKey)
        {
            if let refreshedToken = InstanceID.instanceID().token() {
                print("InstanceID token: \(refreshedToken)")
                UserManager.manager.userToken = refreshedToken
            }
        }
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    func connectToFcm()
    {
        Messaging.messaging().connect { (error) in
            print("Error in connecting to FCM \(String(describing: error))")
        }
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
        
        // unregister from firebase messaging and from walla messaging server
//        FIRInstanceID.instanceID().delete(handler: { (error) in
//            
//        })
        // register to firebase messaging and to walla messaging server
//        FIRInstanceID.instanceID().token()
    }
}


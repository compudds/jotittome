//
//  AppDelegate.swift
//  jotittome
//
//  Created by Eric Cook on 3/25/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import Parse
import Bolts
//import PushNotificationManager


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PushNotificationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //Parse.setApplicationId("qckvk3HZYS8ovGdqG5oOr4fiCt8Ey0lIxwm1n86J", clientKey: "kLqIdAhBh48TSwryESMxHWJxBoOjBN1QJPMBTlwX")
        
        Parse.enableLocalDatastore()
        
        let parseConfiguration = ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
            ParseMutableClientConfiguration.applicationId = "jotittome647stgr^YHBd"
            ParseMutableClientConfiguration.clientKey = "gfdsdtTFB%%^%$U^JYJNDRDE$"
            ParseMutableClientConfiguration.server = "https://jotittome-1.herokuapp.com/parse"
        })
        
        Parse.initializeWithConfiguration(parseConfiguration)
        
        PushNotificationManager.pushManager().delegate = self
        PushNotificationManager.pushManager().handlePushReceived(launchOptions)
        PushNotificationManager.pushManager().sendAppOpen()
        PushNotificationManager.pushManager().registerForPushNotifications()

        
        //PFUser.enableAutomaticUser()

        //PFFacebookUtils.initializeFacebook()
        
       
        //var pushSettings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: .Alert, categories: nil)
        /*var pushSettings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Badge | UIUserNotificationType.Sound | UIUserNotificationType.Alert, categories: nil)
        application.registerUserNotificationSettings(pushSettings)
        application.registerForRemoteNotifications()*/
        
        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector(Selector("backgroundRefreshStatus"))
            let oldPushHandlerOnly = !self.respondsToSelector(#selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        if application.respondsToSelector(#selector(UIApplication.registerUserNotificationSettings(_:))) {
            let userNotificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            let types: UIUserNotificationType = [UIUserNotificationType.Badge, UIUserNotificationType.Alert, UIUserNotificationType.Sound]
            application.registerForRemoteNotifications()   //registerForRemoteNotifications(types)
            
            //let types = UIRemoteNotificationType.Badge | UIRemoteNotificationType.Alert | UIRemoteNotificationType.Sound
           // application.registerForRemoteNotificationTypes(types)
        }
        
        // Swift
        let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
        
        PushNotificationManager.pushManager().handlePushRegistration(deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
        
        PushNotificationManager.pushManager().handlePushRegistrationFailure(error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
        
        PushNotificationManager.pushManager().handlePushReceived(userInfo)
    }
    
    func onPushAccepted(pushManager: PushNotificationManager!, withNotification pushNotification: [NSObject : AnyObject]!, onStart: Bool) {
        print("Push notification accepted: \(pushNotification)");
    }
    

}


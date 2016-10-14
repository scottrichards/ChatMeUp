//
//  AppDelegate.swift
//  PubNubTest
//
//  Created by Scott Richards on 10/13/16.
//  Copyright © 2016 Scott Richards. All rights reserved.
//

import UIKit
import PubNub

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PNObjectEventListener {

    var window: UIWindow?

    var appState : AppState = AppState()
    
    // Stores reference on PubNub client to make sure what it won't be released.
    var client: PubNub!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        initializePubNub()
        // Subscribe to demo channel with presence observation
       
        return true
    }

    // ------------------------------------
    // MARK: PubNub
    // ------------------------------------
    
    func initializePubNub() {
        let configuration = PNConfiguration(publishKey: "pub-c-02f6dfe1-dc7e-4556-b235-1537b1fd790a", subscribeKey: "sub-c-aeafbae4-9188-11e6-8c91-02ee2ddab7fe")
        configuration.isTLSEnabled = true
        self.client = PubNub.clientWithConfiguration(configuration)
        self.client.subscribeToChannels(["cycling"], withPresence: true)
        self.client.addListener(self)
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


}


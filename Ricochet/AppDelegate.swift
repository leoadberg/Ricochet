//
//  AppDelegate.swift
//  Ricochet
//
//  Created by Tigersushi on 3/26/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import UIKit

var GAME_LEVELS: [Level] = []
var CUSTOM_LEVELS: [CustomLevel] = []
let DEFAULTS: NSUserDefaults = NSUserDefaults.standardUserDefaults()
var UNLOCKED_LEVELS: Int = 0
let FILEMANAGER = NSFileManager.defaultManager()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UNLOCKED_LEVELS = max(DEFAULTS.integerForKey("Unlocked Levels"), 0)
        
        let levelArray = CreateArrayFromPlist("Levels", userDomain: false)
        for (i, item) in levelArray.enumerate() {
            let tempLevel = Level(i, item as! NSDictionary)
            if (i > UNLOCKED_LEVELS){
                tempLevel.lock()
            }
            GAME_LEVELS.append(tempLevel)
        }
        
        let customLevelArray = CreateArrayFromPlist("CustomLevels", userDomain: true)
        for (i, item) in customLevelArray.enumerate() {
            let tempCustomLevel = CustomLevel(i, item as! NSDictionary)
            CUSTOM_LEVELS.append(tempCustomLevel)
        }
        
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


}


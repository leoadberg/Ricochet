//
//  AppDelegate.swift
//  Ricochet
//
//  Created by Tigersushi on 3/26/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import UIKit
import SpriteKit

var GAME_LEVELS: [Level] = []
var CUSTOM_LEVELS: [CustomLevel] = []
let DEFAULTS = UserDefaults.standard
var UNLOCKED_LEVELS: Int = 0
let FILEMANAGER = FileManager.default

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        UNLOCKED_LEVELS = max(DEFAULTS.integer(forKey: "Unlocked Levels"), 0)
        
        let levelArray = CreateArrayFromPlist("Levels", false)
        for (i, item) in levelArray.enumerated() {
            let tempLevel = Level(i, item as! NSDictionary)
            if (i > UNLOCKED_LEVELS){
                tempLevel.lock()
            }
            GAME_LEVELS.append(tempLevel)
        }
        
        let customLevelArray = CreateArrayFromPlist("CustomLevels", true)
        for (i, item) in customLevelArray.enumerated() {
            let tempCustomLevel = CustomLevel(i, item as! NSDictionary)
            CUSTOM_LEVELS.append(tempCustomLevel)
        }
		
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

//Globals because Swift can't do math

let SCREEN: CGRect = UIScreen.main.bounds
let SCREEN_WIDTH: CGFloat = SCREEN.width
let SCREEN_HEIGHT: CGFloat = SCREEN.height
let SCREEN_RATIO: CGFloat = SCREEN.height / SCREEN.width

let SWOVER2: CGFloat = SCREEN_WIDTH / 2
let SWOVER12: CGFloat = SCREEN_WIDTH / 12


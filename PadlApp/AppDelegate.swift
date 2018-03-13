//
//  AppDelegate.swift
//  PadlApp
//
//  Created by Jason Tang on 2/20/18.
//  Copyright © 2018 Padl. All rights reserved.
//

import UIKit
import Parse
let themeColor = UIColor(red: 0.01, green: 0.41, blue: 0.22, alpha: 1.0) //greenish color


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let configuration = ParseClientConfiguration { //configures parse with exisiting server
            $0.applicationId = "37fdef082937aab342cf2d6eac0e0e0d7c0667c6"
            $0.clientKey = "fd3262cc172f3b6a88847e21e6b9e5b98b7979ab"
            $0.server = "http://ec2-52-54-149-34.compute-1.amazonaws.com/parse"
        }
        
        Parse.initialize(with:configuration)
        
        window?.tintColor = themeColor //sets general UI theme color to themeColor

        
        // Override point for customization after application launch.
        return true
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


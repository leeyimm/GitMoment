//
//  AppDelegate.swift
//  GitMoment
//
//  Created by liying on 10/08/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import OcticonsSwift
import Hue

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        // Override point for customization after application launch.
        let reposListController = GTMReposListViewController()
        let reposListNavigationController = GTMNavigationController(rootViewController: reposListController)
        let repoImage = UIImage(octiconsID: .repo, backgroundColor: UIColor.clear, iconColor: UIColor.lightGray, iconScale: 1, size: CGSize(width: 25, height: 25))
        let repoHLImage = UIImage(octiconsID: .repo, backgroundColor: UIColor.clear, iconColor: UIColor(hex: "#239BE7"), iconScale: 1, size: CGSize(width: 25, height: 25))
        reposListNavigationController.tabBarItem = UITabBarItem(title: "repo", image: repoImage, selectedImage: repoHLImage)
        reposListNavigationController.navigationBar.setBackgroundImage(UIImage(named: "navigationBar"), for: .default)
        reposListNavigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        reposListNavigationController.navigationBar.tintColor = UIColor.white
        
        let userRankingController = GTMUserRankingListController()
        let userRankingNavigationController = GTMNavigationController(rootViewController: userRankingController)
        let userImage = UIImage(octiconsID: .octoface, backgroundColor: UIColor.clear, iconColor: UIColor.lightGray, iconScale: 1, size: CGSize(width: 25, height: 25))
        let userHLImage = UIImage(octiconsID: .octoface, backgroundColor: UIColor.clear, iconColor: UIColor(hex: "#239BE7"), iconScale: 1, size: CGSize(width: 25, height: 25))
        userRankingNavigationController.tabBarItem = UITabBarItem(title: "user", image: userImage, selectedImage: userHLImage)
        userRankingNavigationController.navigationBar.setBackgroundImage(UIImage(named: "navigationBar"), for: .default)
        userRankingNavigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        userRankingNavigationController.navigationBar.tintColor = UIColor.white
        
        let searchViewController = GTMSearchViewController()
        let searchNavigationController = GTMNavigationController(rootViewController: searchViewController)
        let searchImage = UIImage(octiconsID: .search, backgroundColor: UIColor.clear, iconColor: UIColor.lightGray, iconScale: 1, size: CGSize(width: 25, height: 25))
        let searchHLImage = UIImage(octiconsID: .search, backgroundColor: UIColor.clear, iconColor: UIColor(hex: "#239BE7"), iconScale: 1, size: CGSize(width: 25, height: 25))
        searchNavigationController.tabBarItem = UITabBarItem(title: "search", image: searchImage, selectedImage: searchHLImage)
        searchNavigationController.navigationBar.setBackgroundImage(UIImage(named: "navigationBar"), for: .default)
        searchNavigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        searchNavigationController.navigationBar.tintColor = UIColor.white
        
        let accountViewController = GTMAccountViewController()
        let accountNavigationController = GTMNavigationController(rootViewController: accountViewController)
        let accountImage = UIImage(octiconsID: .person, backgroundColor: UIColor.clear, iconColor: UIColor.lightGray, iconScale: 1, size: CGSize(width: 25, height: 25))
        let accountHLImage = UIImage(octiconsID: .person, backgroundColor: UIColor.clear, iconColor: UIColor(hex: "#239BE7"), iconScale: 1, size: CGSize(width: 25, height: 25))
        accountNavigationController.tabBarItem = UITabBarItem(title: "account", image: accountImage, selectedImage: accountHLImage)
        accountNavigationController.navigationBar.setBackgroundImage(UIImage(named: "navigationBar"), for: .default)
        accountNavigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        accountNavigationController.navigationBar.tintColor = UIColor.white
        
        let rootTabBarController = GTMTabBarController()
        rootTabBarController.tabBar.tintColor = UIColor(hex: "#239BE7")
        rootTabBarController.viewControllers  = [reposListNavigationController, userRankingNavigationController, searchNavigationController, accountNavigationController]
        
        self.window!.rootViewController = rootTabBarController
        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()
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
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        GTMAPIManager.sharedInstance.processOAuthStep1Response(url)
        return true
    }


}


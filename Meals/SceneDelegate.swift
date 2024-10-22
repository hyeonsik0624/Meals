//
//  SceneDelegate.swift
//  Meals
//
//  Created by 진현식 on 3/15/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = UINavigationController(rootViewController: HomeController())
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        if let lastActivateDate = getLastActivateDate() {
            
            if !Calendar.current.isDate(.now, inSameDayAs: lastActivateDate) {
                DispatchQueue.main.async {
                    if let homeVC = self.window?.rootViewController?.children.first as? HomeController {
                        homeVC.currentDate = .now
                        homeVC.updateHome()
                    }
                }
            }
        }
        
        saveLastActiveDate()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func saveLastActiveDate() {
        let date = Date()
        
        UserDefaults.standard.set(date, forKey: "lastActivateDate")
    }
    
    func getLastActivateDate() -> Date? {
        return UserDefaults.standard.object(forKey: "lastActivateDate") as? Date
    }

}


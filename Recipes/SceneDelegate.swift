//
//  SceneDelegate.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/10/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import StoreKit
import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private let environment = AppEnvironment()
    private lazy var store = AppStore(
        initialState: AppState(),
        reducer: appReducer,
        environment: environment
    )

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(
                rootView: RootView()
                    .environmentObject(store)
                    .accentColor(.green)
            )
            self.window = window
            window.makeKeyAndVisible()
        }

        store.send(.load)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        store.send(.save)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        environment.counter.launch()

        if let scene = scene as? UIWindowScene, environment.counter.isReadyToRate {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

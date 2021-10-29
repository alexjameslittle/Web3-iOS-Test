//
//  ArgentTestApp.swift
//  ArgentTest
//
//  Created by Alex Little on 29/10/2021.
//

import App
import Environment
import BlockchainClientLive
import SwiftUI
import ComposableArchitecture

extension AppEnvironment {
    static let live = AppEnvironment(
        blockchainClient: .live,
        mainQueue: .main,
        backgroundQueue: DispatchQueue.global().eraseToAnyScheduler()
    )
}

let store = Store(initialState: AppState(), reducer: appReducer, environment: .live)

@main
struct ArgentTestApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(store: store)
        }
    }
}

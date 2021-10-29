//
//  File.swift
//  
//
//  Created by Alex Little on 29/10/2021.
//

import CatalogUI
import ComposableArchitecture
import SwiftUI

public struct AppView: View {
    @Environment(\.scenePhase) var scenePhase
    
    let store: Store<AppState, AppAction>
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>
    
    public init(store: Store<AppState, AppAction>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }
    
    public var body: some View {
        NavigationView {
            CUIWalletView(
                model: .init(
                    balanceText: viewStore.balanceToDisplay
                ),
                onTapSendEth: {
                    
                },
                onTapViewTransfers: {
                    
                }
            )
                .onAppear {
                    viewStore.send(.fetchBalance)
                }
                .onChange(of: scenePhase) { phase in
                    if phase == .active {
                        viewStore.send(.fetchBalance)
                    }
                }
                .navigationBarHidden(true)
        }
        
    }
}

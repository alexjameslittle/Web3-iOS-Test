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
            ZStack {
                NavigationLink(
                    tag: AppState.Push.ercTransfers,
                    selection: viewStore.binding(get: \.push, send: AppAction.hidePush),
                    destination: {
                        TransfersView(store: store.scope(state: \.transfers, action: AppAction.transfers))
                    },
                    label: { EmptyView() }
                )
                
                CUIWalletView(
                    model: .init(
                        balanceText: viewStore.balanceToDisplay
                    ),
                    onTapSendEth: {
                        viewStore.send(.sendTestEther)
                    },
                    onTapViewTransfers: {
                        viewStore.send(.showERC20Transfers)
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
                    
            }
            .navigationBarHidden(true)
            
        }
        
    }
}

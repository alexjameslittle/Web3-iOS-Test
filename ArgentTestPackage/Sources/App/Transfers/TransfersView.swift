//
//  File.swift
//  
//
//  Created by Alex Little on 30/10/2021.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import CatalogUI

struct TransfersView: View {
    let store: Store<TransfersState, TransfersAction>
    @ObservedObject var viewStore: ViewStore<TransfersState, TransfersAction>
    
    init(store: Store<TransfersState, TransfersAction>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }
    
    var body: some View {
        CUITransfersView(
            model: .init(
                transfers: viewStore.erc20Transfers
            )
        )
            .onAppear {
                viewStore.send(.fetchTransfers)
            }
            .navigationBarHidden(false)
            .navigationTitle(Text("ERC20 Tokens"))
            .navigationBarTitleDisplayMode(.inline)
    }
}

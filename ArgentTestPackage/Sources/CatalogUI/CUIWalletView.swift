//
//  SwiftUIView.swift
//  
//
//  Created by Alex Little on 29/10/2021.
//

import SwiftUI

public struct CUIWalletView: View {
    public let model: Model
    public let onTapSendEth: () -> Void
    public let onTapViewTransfers: () -> Void
    
    public init(
        model: Model,
        onTapSendEth: @escaping () -> Void,
        onTapViewTransfers: @escaping () -> Void
    ) {
        self.model = model
        self.onTapSendEth = onTapSendEth
        self.onTapViewTransfers = onTapViewTransfers
    }
    
    public var body: some View {
        VStack {
            Spacer()
            
            Text("Wallet Balance")
                .font(.title)
            Text(model.balanceText)
                .font(.largeTitle.bold())
            
            Spacer()
            
            Button {
                onTapSendEth()
            } label: {
                Text("Send 0.01 ETH")
            }
            
            Spacer()
            
            Button {
                onTapViewTransfers()
            } label: {
                Text("View ERC20 Transfers")
            }

            Spacer()
        }
    }
}

extension CUIWalletView {
    public struct Model: Equatable {
        public let balanceText: String
        
        public init(
            balanceText: String
        ) {
            self.balanceText = balanceText
        }
    }
}

struct CUIWalletView_Previews: PreviewProvider {
    static var previews: some View {
        CUIWalletView(
            model: .init(
                balanceText: "3.76 ETH"
            ),
            onTapSendEth: { },
            onTapViewTransfers: { }
        )
    }
}

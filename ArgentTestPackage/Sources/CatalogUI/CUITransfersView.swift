//
//  SwiftUIView.swift
//  
//
//  Created by Alex Little on 30/10/2021.
//

import SwiftUI
import Models

private extension ERC20Transfer {
    var fromDisplayText: String {
        return "From: \(from)"
    }
    
    var tokenDisplayText: String {
        return "Token: \(token)"
    }
    
    var valueDisplayText: String {
        return "Value: \(value.description)"
    }
}

public struct CUITransfersView: View {
    public var model: Model
    
    public init(model: Model) {
        self.model = model
    }
    
    public var body: some View {
        List {
            ForEach(model.transfers) { transfer in
                VStack(alignment: .leading) {
                    Text(transfer.fromDisplayText)
                    Text(transfer.tokenDisplayText)
                    Text(transfer.valueDisplayText)
                }
                .lineLimit(1)
                
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

extension CUITransfersView {
    public struct Model: Equatable {
        public let transfers: [ERC20Transfer]
        
        public init(transfers: [ERC20Transfer]) {
            self.transfers = transfers
        }
    }
}

struct CUITransfersView_Previews: PreviewProvider {
    static var previews: some View {
        CUITransfersView(
            model: .init(
                transfers: [
                    .init(
                        from: UUID().uuidString,
                        token: UUID().uuidString,
                        value: 0.01
                    )
                ]
            )
        )
    }
}

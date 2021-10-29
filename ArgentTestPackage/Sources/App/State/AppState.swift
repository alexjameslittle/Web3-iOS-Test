//
//  File.swift
//  
//
//  Created by Alex Little on 29/10/2021.
//

import Foundation

public struct AppState: Equatable {
    // MARK: - predefined variables for the test
    let argentWalletAddress = "0֗70ABd7F0c9Bdc109b579180B272525880Fb7E0cB"
    let argentWalletPrivateKey = "0xec983791a21bea916170ee0aead71ab95c13280656e93ea4124c447bbd9a24a2"
    let transferManagerModuleAddress = "0xcdAd167a8A9EAd2DECEdA7c8cC908108b0Cc06D1"
    let transferManagerModuleAbi = abi
    
    var balance: Decimal = 0.0
    
    var balanceToDisplay: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .down
        
        let number = NSDecimalNumber(decimal: balance)
        let formattedValue = formatter.string(from: number)!
        return "\(formattedValue) ETH"
    }
    
    var isFetchingBalance = false
    
    public init() {
    }
}

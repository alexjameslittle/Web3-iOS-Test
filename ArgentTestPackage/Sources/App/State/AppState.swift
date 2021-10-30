//
//  File.swift
//  
//
//  Created by Alex Little on 29/10/2021.
//

import Foundation

public struct AppState: Equatable {
    // MARK: - Balance
    var balance: Decimal = 0.0
    var isFetchingBalance = false
    
    var balanceToDisplay: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .down
        
        let number = NSDecimalNumber(decimal: balance)
        let formattedValue = formatter.string(from: number)!
        return "\(formattedValue) ETH"
    }
    
    // MARK: - Transfers
    
    var transfers = TransfersState()
    
    // MARK: - Navigation
    
    enum Push {
        case ercTransfers
    }
    var push: Push?
    
    public init() {
    }
}

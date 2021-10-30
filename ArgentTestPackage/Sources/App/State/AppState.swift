//
//  File.swift
//  
//
//  Created by Alex Little on 29/10/2021.
//

import Foundation

public struct AppState: Equatable {
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
